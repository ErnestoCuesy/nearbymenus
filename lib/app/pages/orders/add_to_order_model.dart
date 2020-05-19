import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/order_item.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';

class AddToOrderModel with ChangeNotifier {
  final Database database;
  final Session session;
  String menuCode;
  Map<String, dynamic> item;
  Map<String, dynamic> options;
  bool isLoading;
  bool submitted;
  List<String> menuItemOptions = List<String>();
  List<String> tempMenuItemOptions = List<String>();
  Map<String, int> optionsSelectionCounters = Map<String, int>();
  int quantity = 1;
  double lineTotal = 0;
  String menuCodeAndItemName = '';

  AddToOrderModel(
      {@required this.database,
        @required this.session,
        @required this.menuCode,
        @required this.item,
        @required this.options,
        this.isLoading = false,
        this.submitted = false,
      });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    _addMenuItemToOrder();
  }

  void _addMenuItemToOrder() {
    final double timestamp = dateFromCurrentDate() / 1.0;
    var orderNumber = documentIdFromCurrentDate();
    if (session.currentOrder == null) {
      session.currentOrder = Order(
          id: orderNumber,
          restaurantId: session.nearestRestaurant.id,
          restaurantName: session.nearestRestaurant.name,
          managerId: session.nearestRestaurant.managerId,
          userId: database.userId,
          timestamp: timestamp,
          status: ORDER_ON_HOLD,
          name: session.userDetails.name,
          deliveryAddress: '${session.userDetails.address} ${session.nearestRestaurant.restaurantLocation}',
          orderItems: List<Map<String, dynamic>>(),
          notes: ''
      );
    } else {
      orderNumber = session.currentOrder.id;
    }
    final orderItem = OrderItem(
      id: documentIdFromCurrentDate(),
      orderId: orderNumber,
      menuCode: menuCode,
      name: item['name'],
      quantity: quantity,
      price: item['price'],
      lineTotal: lineTotal,
      options: tempMenuItemOptions,
    ).toMap();
    session.currentOrder.orderItems.add(orderItem);
    session.currentOrder.status = ORDER_ON_HOLD;
    print(orderItem);
  }

  String get primaryButtonText => 'Save';

  bool get canSave => _optionsAreValid();

  bool _optionsAreValid() {
    if (item['options'].isEmpty) {
      return true;
    }
    if (optionsSelectionCounters.isEmpty) {
      return false;
    }
    bool optionsAreValid = true;
    item['options'].forEach((key) {
      Map<String, dynamic> optionValue = options[key];
      final maxAllowed = optionValue['numberAllowed'];
      if (optionsSelectionCounters[optionValue['name']] == null ||
          optionsSelectionCounters[optionValue['name']] > maxAllowed ||
          optionsSelectionCounters[optionValue['name']] == 0) {
        optionsAreValid = false;
      }
    });
    return optionsAreValid;
  }

  void updateQuantity(int quantity) {
    final qty = this.quantity += quantity;
    final lineTotal = item['price'] * qty;
    updateWith(quantity: qty, lineTotal: lineTotal);
  }

  void updateOptionsList(String key, String option, bool addFlag) {
      if (addFlag) {
        tempMenuItemOptions.add(option);
        if (optionsSelectionCounters.containsKey(key)) {
          optionsSelectionCounters.update(key, (value) => value + 1);
        } else {
          optionsSelectionCounters.putIfAbsent(key, () => 1);
        }
      } else {
        tempMenuItemOptions.remove(option);
        if (optionsSelectionCounters.containsKey(key)) {
          optionsSelectionCounters.update(key, (value) => value - 1);
        } else {
          optionsSelectionCounters.putIfAbsent(key, () => 0);
        }
      }
      updateWith(menuItemOptions: tempMenuItemOptions);
  }

  bool optionCheck(String key) => menuItemOptions.contains(key);

  void updateWith({
    List<String> menuItemOptions,
    int quantity,
    double lineTotal,
    bool isLoading,
    bool submitted,
  }) {
    this.menuItemOptions = menuItemOptions ?? this.menuItemOptions;
    this.quantity = quantity ?? this.quantity;
    this.lineTotal = lineTotal ?? this.lineTotal;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
