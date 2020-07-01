import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<int> get orderDistance async {
    double distance = await Geolocator().distanceBetween(
      session.position.latitude,
      session.position.longitude,
      order.deliveryPosition.latitude,
      order.deliveryPosition.longitude,
    );
    return distance.round();
  }

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
      order.deliveryPosition = session.position;
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
      attendedFlag: false,
    ));

  }

  void processOrder(int newOrderStatus) {
    try {
      order.status = newOrderStatus;
      database.setOrder(order);
      if (newOrderStatus == ORDER_CANCELLED) {
        database.setBundleCounterTransaction(session.currentRestaurant.managerId, 1);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    String message;
    switch (newOrderStatus) {
      case ORDER_ACCEPTED:
        message = '${session.currentRestaurant.name} is processing your order!';
        break;
      case ORDER_READY:
        message = 'Your order is ready!';
        break;
      case ORDER_DELIVERING:
        message = 'Your order is on it\'s way!';
        break;
      case ORDER_REJECTED_BUSY:
        message = 'We can\'t process your order at the moment, sorry.';
        break;
      case ORDER_REJECTED_STOCK:
        message = 'We\'re out of stock on one or more items.';
        break;
    }
    if (newOrderStatus != ORDER_CLOSED &&
        newOrderStatus != ORDER_CANCELLED) {
      _sendMessage(
          order.userId,
          ROLE_STAFF,
          ROLE_PATRON,
          message
      );
    }
  }

  void cancelOnHoldOrder() {
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
    int deliveryOptionsAvailable = 0;
    session.currentRestaurant.foodDeliveryFlags.forEach((key, value) {
      if (value) deliveryOptionsAvailable++;
    });
    bool deliveryOptionsOk = false;
    if (deliveryOptionsAvailable > 0) {
      if (order.deliveryOption != '') {
        deliveryOptionsOk = true;
      }
    } else {
      deliveryOptionsOk = true;
    }
    return order.paymentMethod != '' &&
           deliveryOptionsOk &&
           order.orderTotal > 0;
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

  void updateFoodDeliveryOption(String key, bool flag) {
    if (order.status != ORDER_ON_HOLD) {
      return;
    }
    if (flag) {
      updateWith(deliveryOption: key);
    } else {
      updateWith(deliveryOption: '');
    }
  }

  bool paymentOptionCheck(String key) => order.paymentMethod == key;

  bool foodDeliveryOptionCheck(String key) => order.deliveryOption == key;

  bool canDoThis(int processStep) {
    bool proceed;
    switch (processStep) {
      case ORDER_ACCEPTED:
        if (order.status == ORDER_PLACED) {
          proceed = true;
        } else {
          proceed = false;
        }
        break;
      case ORDER_READY:
        if (order.status == ORDER_ACCEPTED) {
          proceed = true;
        } else {
          proceed = false;
        }
        break;
      case ORDER_REJECTED_BUSY:
      case ORDER_REJECTED_STOCK:
        if (order.status == ORDER_PLACED) {
          proceed = true;
        } else {
          proceed = false;
        }
        break;
      case ORDER_DELIVERING:
        if (order.status == ORDER_READY && order.deliveryOption == 'Deliver') {
          proceed = true;
        } else {
          proceed = false;
        }
        break;
      case ORDER_CLOSED:
        if (order.status == ORDER_READY ||
            order.status == ORDER_DELIVERING) {
          proceed = true;
        } else {
          proceed = false;
        }
        break;
    }
    return proceed;
  }

  void updateWith({
    String notes,
    String paymentMethod,
    String deliveryOption,
    bool isLoading,
    bool submitted,
  }) {
    this.order.notes = notes ?? this.order.notes;
    this.order.paymentMethod = paymentMethod ?? this.order.paymentMethod;
    this.order.deliveryOption = deliveryOption ?? this.order.deliveryOption;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
