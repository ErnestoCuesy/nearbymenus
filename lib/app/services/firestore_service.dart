import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<void> deleteCollectionData({
    @required String collectionPath,
    @required String fieldName,
    @required String fieldValue
  }) async {
    print('$collectionPath, $fieldValue, $fieldValue');
    FirebaseFirestore.instance
        .collection(collectionPath)
        .where(fieldName, isEqualTo: fieldValue)
        .get()
        .then((value) {
          value.docs.forEach((element) {
            print('$collectionPath/${element.id}');
            deleteData(path: '$collectionPath/${element.id}');
          });
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Future<List<T>> collectionSnapshot<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(path).get();
    return snapshot.docs.map((snaps) => builder(snaps.data(), snaps.id)).toList();
  }

  Future<T> documentSnapshot<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Future<DocumentSnapshot> snapshots = reference.get();
    return snapshots.then((value) => builder(value.data(), value.id));
  }

  Future<int> runUpdateCounterTransaction({
    @required String counterPath,
    @required String documentId,
    @required String fieldName,
    @required int quantity,
  }) async {
    int updatedCounter;
    DocumentReference document = FirebaseFirestore.instance.collection(counterPath).doc(documentId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(document);
      if (freshSnap.exists) {
        updatedCounter = freshSnap.data()['$fieldName'] + quantity;
        transaction.update(freshSnap.reference, {
          '$fieldName': updatedCounter,
        });
      } else {
        transaction.set(document, {
          '$fieldName': quantity,
        });
      }
    }).catchError((e) {
      print('Transaction failed: $updatedCounter');
    })
    .whenComplete(() => {
      print('Transaction completed: $updatedCounter')
    });
    return updatedCounter;
  }

  Future<void> runSetOrderTransaction({
    @required String orderNumberPath,
    @required String orderNumberDocumentId,
    @required String orderNumberFieldName,
    @required String bundleCounterPath,
    @required String bundleCounterDocumentId,
    @required String bundleCounterFieldName,
    @required String orderPath,
    @required String orderDocumentId,
    @required Map<String, dynamic> orderData,
  }) async {
    DocumentReference orderNumberDocument = FirebaseFirestore.instance.collection(orderNumberPath).doc(orderNumberDocumentId);
    DocumentReference bundleCounterDocument = FirebaseFirestore.instance.collection(bundleCounterPath).doc(bundleCounterDocumentId);
    DocumentReference orderDocument = FirebaseFirestore.instance.collection(orderPath).doc(orderDocumentId);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot freshSnapOrderNumber = await transaction.get(orderNumberDocument);
            DocumentSnapshot freshSnapOrder = await transaction.get(orderDocument);
            DocumentSnapshot freshSnapBundleCounter = await transaction.get(bundleCounterDocument);
            // ORDER NUMBER PROCESSING
            int newOrderNumber;
            if (freshSnapOrderNumber.exists) {
              newOrderNumber = freshSnapOrderNumber.data()['$orderNumberFieldName'] + 1;
              transaction.update(freshSnapOrderNumber.reference, {
                '$orderNumberFieldName': newOrderNumber,
              });
            } else {
              newOrderNumber = 1;
              transaction.set(orderNumberDocument, {
                '$orderNumberFieldName': newOrderNumber,
              });
            }
            // BUNDLE COUNTER PROCESSING
            int newBundleCounter;
            if (freshSnapBundleCounter.exists) {
              newBundleCounter = freshSnapBundleCounter.data()['$bundleCounterFieldName'] - 1;
              transaction.update(freshSnapBundleCounter.reference, {
                '$bundleCounterFieldName': newBundleCounter,
              });
            } else {
              newBundleCounter = -1;
              transaction.set(bundleCounterDocument, {
                '$bundleCounterFieldName': newBundleCounter,
              });
            }
            // ORDER PROCESSING
            orderData['orderNumber'] = newOrderNumber;
            if (newBundleCounter < 0) {
              orderData['isBlocked'] = true;
            }
            if (freshSnapOrder.exists) {
              transaction.update(freshSnapOrder.reference, orderData);
            } else {
              transaction.set(orderDocument, orderData);
            }
          }).catchError((e) {
            print('Transaction failed: $e');
          })
            .whenComplete(() {
            print('Transaction completed');
          });
    } catch (e) {
      print('Try catch failed: $e');
      rethrow;
    }
  }
}

