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
    _sendMessage();
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
      database.setUserDetails(session.userDetails);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _sendMessage() async {
    final double timestamp = dateFromCurrentDate() / 1.0;
    database.setMessageDetails(UserMessage(
      id: documentIdFromCurrentDate(),
      timestamp: timestamp,
      fromUid: database.userId,
      toUid: session.currentRestaurant.managerId,
      restaurantId: session.currentRestaurant.id,
      fromRole: ROLE_PATRON,
      toRole: ROLE_STAFF,
      fromName: session.userDetails.name,
      delivered: false,
      type: 'New order to ${session.currentRestaurant.name}',
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
  }

  void cancel() {
    order = null;
    session.userDetails.orderOnHold = null;
    session.currentOrder = null;
    database.setUserDetails(session.userDetails);
  }

  void updateNotes(String notes) => updateWith(notes: notes);

  void deleteOrderItem(int index) {
      order.orderItems.removeAt(index);
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
