import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_message.dart';
import 'package:nearbymenus/app/services/database.dart';

class ViewOrderModel with ChangeNotifier {
  final Database database;
  final Session session;
  Order order;
  bool isLoading;
  bool submitted;

  ViewOrderModel(
      {@required this.database,
        @required this.session,
        @required this.order,
        this.isLoading = false,
        this.submitted = false,
      });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    _submitOrder();
    _sendMessage(
        session.currentRestaurant.managerId,
        ROLE_PATRON,
        ROLE_STAFF,
        'New order to ${session.currentRestaurant.name}'
    );
  }

  Future<void> _submitOrder() async {
    try {
      order.id = documentIdFromCurrentDate();
      order.timestamp = dateFromCurrentDate() / 1.0;
      order.status = ORDER_PLACED;
      database.setOrderTransaction(session.currentRestaurant.managerId,
          session.currentRestaurant.id,
          order);
      session.currentOrder = null;
      session.userDetails.orderOnHold = null;
      _setUserDetails();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _sendMessage(String toUid, String fromRole, String toRole, String type) async {
    final double timestamp = dateFromCurrentDate() / 1.0;
    database.setMessageDetails(UserMessage(
      id: documentIdFromCurrentDate(),
      timestamp: timestamp,
      fromUid: database.userId,
      toUid: toUid,
      restaurantId: session.currentRestaurant.id,
      fromRole: fromRole,
      toRole: toRole,
      fromName: session.userDetails.name,
      delivered: false,
      type: type,
      authFlag: false,
    ));

  }

  void processOrder(int newOrderStatus) {
    try {
      order.status = newOrderStatus;
      database.setOrder(order);
    } catch (e) {
      print(e);
      rethrow;
    }
    String message;
    switch (newOrderStatus) {
      case ORDER_ACCEPTED:
        message = '${session.currentRestaurant.name} is processing your order!';
        break;
      case ORDER_DISPATCHED:
        message = 'Your order is on it\'s way!';
        break;
      case ORDER_REJECTED:
        message = 'We can\'t process your order, sorry.';
        break;
    }
    _sendMessage(
        order.userId,
        ROLE_STAFF,
        ROLE_PATRON,
        message
    );
  }

  void cancel() {
    order = null;
    session.userDetails.orderOnHold = null;
    session.currentOrder = null;
    _setUserDetails();
  }

  void _setUserDetails() {
    database.setUserDetails(session.userDetails);
  }

  void updateNotes(String notes) => updateWith(notes: notes);

  void deleteOrderItem(int index) {
      order.orderItems.removeAt(index);
      session.userDetails.orderOnHold = order.toMap();
      _setUserDetails();
      notifyListeners();
  }
  
  String get primaryButtonText => 'Save';

  bool get canSave => _checkOrder();

  bool _checkOrder() {
    return order.paymentMethod != '' && order.orderTotal > 0;
  }

  void updatePaymentMethod(String key, bool flag) {
    if (order.status != ORDER_ON_HOLD) {
      return;
    }
    if (flag) {
      updateWith(paymentMethod: key);
    } else {
      updateWith(paymentMethod: '');
    }
  }

  bool optionCheck(String key) => order.paymentMethod == key;

  void updateWith({
    String notes,
    String paymentMethod,
    bool isLoading,
    bool submitted,
  }) {
    this.order.notes = notes ?? this.order.notes;
    this.order.paymentMethod = paymentMethod ?? this.order.paymentMethod;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
