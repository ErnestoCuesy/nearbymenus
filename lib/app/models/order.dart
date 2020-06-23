import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

const int ORDER_ON_HOLD = 0;
const int ORDER_PLACED = 1;
const int ORDER_ACCEPTED = 2;
const int ORDER_READY = 3;
const int ORDER_REJECTED = 4;
const int ORDER_CANCELLED = 5;
const int ORDER_DELIVERING = 6;
const int ORDER_CLOSED = 7;

class Order {
  String id;
  int orderNumber;
  final String restaurantId;
  final String restaurantName;
  final String managerId;
  final String userId;
  double timestamp;
  int status;
  final String name;
  final String deliveryAddress;
  Position deliveryPosition;
  String paymentMethod;
  List<Map<dynamic, dynamic>> orderItems;
  String notes;
  bool isBlocked;

  Order({
    this.id,
    this.orderNumber,
    this.restaurantId,
    this.restaurantName,
    this.managerId,
    this.userId,
    this.timestamp,
    this.status,
    this.name,
    this.deliveryAddress,
    this.deliveryPosition,
    this.paymentMethod,
    this.orderItems,
    this.notes,
    this.isBlocked,
  });

  factory Order.fromMap(Map<dynamic, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    final geoPoint = data['deliveryPosition'] as GeoPoint;
    List<Map<dynamic, dynamic>> orderItems;
    if (data['orderItems'] != null) {
      orderItems = List.from(data['orderItems']);
    } else {
      orderItems = List<Map<dynamic, dynamic>>();
    }
    return Order(
      id: data['id'],
      orderNumber: data['orderNumber'],
      restaurantId: data['restaurantId'],
      restaurantName: data['restaurantName'],
      managerId: data['managerId'],
      userId: data['userId'],
      timestamp: data['timestamp'],
      status: data['status'],
      name: data['name'],
      deliveryAddress: data['deliveryAddress'],
      deliveryPosition: Position(
          latitude: geoPoint.latitude, longitude: geoPoint.longitude),
      paymentMethod: data['paymentMethod'],
      orderItems: orderItems,
      notes: data['notes'],
      isBlocked: data['isBlocked'],
    );
  }

  double get orderTotal {
    double total = 0;
    orderItems.forEach((element) {
      Map<dynamic, dynamic> item = element;
      total += item['lineTotal'];
    });
    return total;
  }

  Map<String, dynamic> toMap() {
    final GeoPoint geoPoint =
    GeoPoint(deliveryPosition.latitude, deliveryPosition.longitude);
    return {
      'id': id,
      'orderNumber': orderNumber,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'managerId': managerId,
      'userId': userId,
      'timestamp': timestamp,
      'status': status,
      'name': name,
      'deliveryAddress': deliveryAddress,
      'deliveryPosition': geoPoint,
      'paymentMethod': paymentMethod ?? '',
      'orderItems': orderItems ?? [],
      'notes': notes,
      'isBlocked': isBlocked ?? false,
    };
  }

  String get statusString {
    String stString = '';
    switch (status) {
      case ORDER_ON_HOLD:
        stString = 'On hold';
        break;
      case ORDER_PLACED:
        stString = 'Placed, pending';
        break;
      case ORDER_ACCEPTED:
        stString = 'Accepted, in progress';
        break;
      case ORDER_READY:
        stString = 'Ready';
        break;
      case ORDER_REJECTED:
        stString = 'Rejected by staff';
        break;
      case ORDER_CANCELLED:
        stString = 'Cancelled by patron';
        break;
      case ORDER_DELIVERING:
        stString = 'Being delivered';
        break;
      case ORDER_CLOSED:
        stString = 'Delivered, closed';
        break;
    }
    return stString;
  }

  @override
  String toString() {
    return 'id: $id, orderNumber: $orderNumber, restaurantId: $restaurantId, restaurantName: $restaurantName, managerId: $managerId, userId: $userId, timestamp: $timestamp, status: $status, name: $name, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, orderItems: $orderItems, notes: $notes, isBlocked: $isBlocked';
  }

}
