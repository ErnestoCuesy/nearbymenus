import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/menu_item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/option.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuItemDetailsModel with MenuItemValidators, ChangeNotifier {
  final Database database;
  final Session session;
  final Menu menu;
  Restaurant restaurant;
  String id;
  String name;
  String description;
  List<String> optionIdList;
  double price;
  bool isExtra;
  bool isLoading;
  bool submitted;

  Map<String, dynamic> restaurantObjectStagedOptions;
  Map<String, Option> stagedOptions = {};

  MenuItemDetailsModel(
      {@required this.database,
       @required this.session,
       @required this.menu,
       @required this.restaurant,
        this.id,
        this.name,
        this.description,
        this.price = 0.00,
        this.optionIdList,
        this.isExtra,
        this.isLoading = false,
        this.submitted = false,
      }) {
    restaurantObjectStagedOptions = restaurant.restaurantOptions;
    if (id == null || id == '') {
      id = documentIdFromCurrentDate();
    }
  }
  
  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    final item = MenuItem(
      id: id,
      menuId: menu.id,
      name: name,
      description: description,
      price: price,
      options: optionIdList,
      isExtra: isExtra,
    );
    try {
      await database.setMenuItem(item);
      final Map<dynamic, dynamic> items = restaurant.restaurantMenus[menu.id];
      if (items.containsKey(id)) {
        restaurant.restaurantMenus[menu.id].update(id, (_) => item.toMap());
      } else {
        restaurant.restaurantMenus[menu.id].putIfAbsent(id, () => item.toMap());
      }
      restaurant.restaurantOptions = restaurantObjectStagedOptions;
      await Restaurant.setRestaurant(database, restaurant);
      if (stagedOptions != null) {
        stagedOptions.forEach((key, value) async {
          await database.setOption(value);
        });
      }
    } catch (e) {
      print(e);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText => 'Save';

  bool get canSave => menuItemNameValidator.isValid(name) &&
      menuItemDescriptionValidator.isValid(description) &&
      menuItemPriceValidator.isValid(price);

  String get menuItemNameErrorText {
    bool showErrorText = !menuItemNameValidator.isValid(name);
    return showErrorText ? invalidMenuItemNameText : null;
  }

  String get menuItemDescriptionErrorText {
    bool showErrorText = !menuItemDescriptionValidator.isValid(description);
    return showErrorText ? invalidMenuItemDescriptionText : null;
  }

  String get menuItemPriceErrorText {
    bool showErrorText = !menuItemPriceValidator.isValid(price);
    return showErrorText ? invalidMenuItemPriceText : null;
  }

  void updateMenuItemName(String name) => updateWith(name: name);

  void updateMenuItemDescription(String description) => updateWith(description: description);

  void updateMenuItemPrice(String price) {
   var amount = price.replaceAll(RegExp(r','), '.');
   updateWith(price: double.tryParse(amount));
  }

  void updateMenuItemIsExtra(bool isExtra) => updateWith(isExtra: isExtra);

  bool optionCheck(String key) => optionIdList.contains(key);

  void updateOptionIdList(String key, bool value) {
    final newOptionIdList = optionIdList;
    Map<String, dynamic> option = restaurantObjectStagedOptions[key];
    stagedOptions[key] = Option.fromMap(option, null);
    List<dynamic> usedByMenuItems = option['usedByMenuItems'] ?? [];
    if (value) {
      newOptionIdList.add(key);
      usedByMenuItems.add(id);
    } else {
      newOptionIdList.remove(key);
      usedByMenuItems.remove(id);
    }
    restaurantObjectStagedOptions[key]['usedByMenuItems'] = usedByMenuItems;
    stagedOptions[key].usedByMenuItems = usedByMenuItems;
    updateWith(optionIdList: newOptionIdList);
  }

  void updateWith({
    String name,
    String description,
    double price,
    List<String> optionIdList,
    bool isExtra,
    bool isLoading,
    bool submitted,
  }) {
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.price = price ?? this.price;
    this.optionIdList = optionIdList ?? this.optionIdList;
    this.isExtra = isExtra ?? this.isExtra;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
