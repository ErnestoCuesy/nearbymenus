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
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) => builder(snapshot.data, snapshot.documentID))
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
    Firestore.instance
        .collection(collectionPath)
        .where(fieldName, isEqualTo: fieldValue)
        .getDocuments()
        .then((value) {
          value.documents.forEach((element) {
            print('$collectionPath/${element.documentID}');
            deleteData(path: '$collectionPath/${element.documentID}');
          });
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data, snapshot.documentID));
  }

  Future<List<T>> collectionSnapshot<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) async {
    final QuerySnapshot snapshot = await Firestore.instance.collection(path).getDocuments();
    return snapshot.documents.map((snaps) => builder(snaps.data, snaps.documentID)).toList();
  }

  Future<T> documentSnapshot<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Future<DocumentSnapshot> snapshots = reference.get();
    return snapshots.then((value) => builder(value.data, value.documentID));
  }

  Future<int> runUpdateCounterTransaction({
    @required String counterPath,
    @required String documentId,
    @required String fieldName,
    @required int quantity,
  }) async {
    int updatedCounter;
    DocumentReference document = Firestore.instance.collection(counterPath).document(documentId);
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(document);
      if (freshSnap.exists) {
        updatedCounter = freshSnap['$fieldName'] + quantity;
        await transaction.update(freshSnap.reference, {
          '$fieldName': updatedCounter,
        }).catchError((e) {
          print('Update counter failed: $updatedCounter');
        })
        .whenComplete(() {
          print('Update counter completed: $updatedCounter');
        });
      } else {
        await transaction.set(document, {
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
    DocumentReference orderNumberDocument = Firestore.instance.collection(orderNumberPath).document(orderNumberDocumentId);
    DocumentReference bundleCounterDocument = Firestore.instance.collection(bundleCounterPath).document(bundleCounterDocumentId);
    DocumentReference orderDocument = Firestore.instance.collection(orderPath).document(orderDocumentId);
    try {
      await Firestore.instance.runTransaction((transaction) async {
            DocumentSnapshot freshSnapOrderNumber = await transaction.get(orderNumberDocument);
            DocumentSnapshot freshSnapOrder = await transaction.get(orderDocument);
            DocumentSnapshot freshSnapBundleCounter = await transaction.get(bundleCounterDocument);
            // ORDER NUMBER PROCESSING
            int newOrderNumber;
            if (freshSnapOrderNumber.exists) {
              newOrderNumber = freshSnapOrderNumber['$orderNumberFieldName'] + 1;
              await transaction.update(freshSnapOrderNumber.reference, {
                '$orderNumberFieldName': newOrderNumber,
              }).catchError((e) {
                print('Order Number Update Failed: $newOrderNumber');
              }).whenComplete(() {
                print('Order Number Update completed: $newOrderNumber');
              });
            } else {
              newOrderNumber = 1;
              await transaction.set(orderNumberDocument, {
                '$orderNumberFieldName': newOrderNumber,
              }).catchError((e) {
                print('Order Number Set Failed: $newOrderNumber');
              }).whenComplete(() {
                print('Order Number Set Completed: $newOrderNumber');
              });
            }
            // BUNDLE COUNTER PROCESSING
            int newBundleCounter;
            if (freshSnapBundleCounter.exists) {
              newBundleCounter = freshSnapBundleCounter['$bundleCounterFieldName'] - 1;
              await transaction.update(freshSnapBundleCounter.reference, {
                '$bundleCounterFieldName': newBundleCounter,
              }).catchError((e) {
                print('Bundle Counter Update Failed: $newBundleCounter');
              }).whenComplete(() {
                print('Bundle Counter Update completed: $newBundleCounter');
              });
            } else {
              newBundleCounter = -1;
              await transaction.set(bundleCounterDocument, {
                '$bundleCounterFieldName': newBundleCounter,
              }).catchError((e) {
                print('Bundle Counter Set Failed: $newBundleCounter');
              }).whenComplete(() {
                print('Bundle Counter Set completed: $newBundleCounter');
              });
            }
            // ORDER PROCESSING
            orderData['orderNumber'] = newOrderNumber;
            if (newBundleCounter < 0) {
              orderData['isBlocked'] = true;
            }
            if (freshSnapOrder.exists) {
              await transaction.update(freshSnapOrder.reference, orderData).catchError((e) {
                print('Order Update Failed: $newOrderNumber');
              }).whenComplete(() {
                print('Order Update Completed: $newOrderNumber');
              });
            } else {
              await transaction.set(orderDocument, orderData).catchError((e) {
                print('Order Set Completed: $newOrderNumber');
              }).whenComplete(() {
                print('Order Set Completed: $newOrderNumber');
              });
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

