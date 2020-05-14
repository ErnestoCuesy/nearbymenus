const int ORDER_ON_HOLD = 0;
const int ORDER_PLACED = 1;
const int ORDER_IN_PROGRESS = 2;
const int ORDER_DISPATCHED = 3;
const int ORDER_CANCELLED = 4;

class Order {
  final String id;
  int orderNumber;
  final String restaurantId;
  final String userId;
  final double timestamp;
  int status;
  final String name;
  final String deliveryAddress;
  String paymentMethod;
  final List<Map<String, dynamic>> orderItems;
  bool isBlocked;

  Order({
    this.id,
    this.orderNumber,
    this.restaurantId,
    this.userId,
    this.timestamp,
    this.status,
    this.name,
    this.deliveryAddress,
    this.paymentMethod,
    this.orderItems,
    this.isBlocked,
  });

  factory Order.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    List<Map<String, dynamic>> orderItems;
    if (data['orderItems'] != null) {
      orderItems = List.from(data['orderItems']);
    } else {
      orderItems = List<Map<String, dynamic>>();
    }
    return Order(
      id: data['id'],
      orderNumber: data['orderNumber'],
      restaurantId: data['restaurantId'],
      userId: data['userId'],
      timestamp: data['timestamp'],
      status: data['status'],
      name: data['name'],
      deliveryAddress: data['deliveryAddress'],
      paymentMethod: data['paymentMethod'],
      orderItems: orderItems,
      isBlocked: data['isBlocked'],
    );
  }

  double get orderTotal {
    double total = 0;
    orderItems.forEach((element) {
      Map<String, dynamic> item = element;
      total += item['lineTotal'];
    });
    return total;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'restaurantId': restaurantId,
      'userId': userId,
      'timestamp': timestamp,
      'status': status,
      'name': name,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod ?? '',
      'orderItems': orderItems ?? [],
      'isBlocked': isBlocked ?? false,
    };
  }

  String get statusString {
    String stString = '';
    switch (status) {
      case 0:
        stString = 'On hold';
        break;
      case 1:
        stString = 'Placed, pending';
        break;
      case 2:
        stString = 'In progress';
        break;
      case 3:
        stString = 'Dispatched';
        break;
      case 4:
        stString = 'Cancelled';
        break;
    }
    return stString;
  }

  @override
  String toString() {
    return 'id: $id, orderNumber: $orderNumber, restaurantId: $restaurantId, userId: $userId, timestamp: $timestamp, status: $status, name: $name, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, orderItems: $orderItems, isBlocked: $isBlocked';
  }

}
