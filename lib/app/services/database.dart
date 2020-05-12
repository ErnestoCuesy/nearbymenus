import 'dart:async';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/menu_item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/option.dart';
import 'package:nearbymenus/app/models/option_item.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/order_item.dart';
import 'package:nearbymenus/app/models/user_message.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  String get userId;
  void setUserId(String uid);
  Future<void> setUserDetails(UserDetails userDetails);
  Stream<UserDetails> userDetailsStream();
  Stream<List<Restaurant>> managerRestaurants(String restaurantId);
  Stream<List<Restaurant>> userRestaurant(String restaurantId);
  Future<List<Restaurant>> patronRestaurants();
  Future<void> setRestaurant(Restaurant restaurant);
  Future<void> setMessageDetails(UserMessage roleNotification);
  Stream<UserMessage> userMessage(String uid);
  Stream<List<UserMessage>> userMessages(String restaurantId, String uid, String toRole);
  Stream<Authorizations> authorizationsStream(String restaurantId);
  Future<void> setAuthorization(String restaurantId, Authorizations authorizations);
  Future<List<Authorizations>> authorizationsSnapshot();
  Future<void> deleteMessage(String id);
  Future<void> deleteRestaurant(Restaurant restaurant);
  Future<void> setMenu(Menu menu);
  Stream<List<Menu>> restaurantMenus(String restaurantId);
  Future<void> deleteMenu(Menu menu);
  Future<void> setMenuItem(MenuItem menuItem);
  Stream<List<MenuItem>> menuItems(String menuItemId);
  Future<void> deleteMenuItem(MenuItem menuItem);
  Future<void> setOption(Option option);
  Stream<List<Option>> restaurantOptions(String restaurantId);
  Future<void> deleteOption(Option option);
  Future<void> setOptionItem(OptionItem optionItem);
  Stream<List<OptionItem>> optionItems(String optionId);
  Future<void> deleteOptionItem(OptionItem optionItem);
  Future<void> setOrder(Order order);
  Stream<List<Order>> restaurantOrders(String restaurantId);
  Future<void> deleteOrder(Order order);
  Stream<List<Order>> userOrders(String restaurantId, String uid);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
int dateFromCurrentDate() => DateTime.now().millisecondsSinceEpoch;

class FirestoreDatabase implements Database {

  String uid;
  final _service = FirestoreService.instance;

  @override
  String get userId => uid;

  @override
  void setUserId(String uid) {
    this.uid = uid;
  }

  // Used by several widgets
  @override
  Future<void> setUserDetails(UserDetails userDetails) async => await _service
      .setData(path: APIPath.userDetails(uid), data: userDetails.toMap());

  // Used by session control
  @override
  Stream<UserDetails> userDetailsStream() => _service.documentStream(
        path: APIPath.userDetails(uid),
        builder: (data, documentId) => UserDetails.fromMap(data),
      );

  // Used by staff authorizations
  @override
  Stream<Authorizations> authorizationsStream(String restaurantId) => _service.documentStream(
    path: APIPath.authorization(restaurantId),
    builder: (data, documentId) => Authorizations.fromMap(data, documentId),
  );

  // Used by nearest restaurant query
  @override
  Future<List<Authorizations>> authorizationsSnapshot() => _service.collectionSnapshot(
    path: APIPath.authorizations(),
    builder: (data, documentId) => Authorizations.fromMap(data, documentId),
  );

  // Used by restaurant details page
  @override
  Stream<List<Restaurant>> managerRestaurants(String managerId) => _service.collectionStream(
    path: APIPath.restaurants(),
    queryBuilder: managerId != null
          ? (query) => query.where('managerId', isEqualTo: managerId)
          : null,
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  // Used by account page to load user's (patron or staff) restaurant
  @override
  Stream<List<Restaurant>> userRestaurant(String restaurantId) => _service.collectionStream(
    path: APIPath.restaurants(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('id', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  // Used by messages listener and messages page widgets
  @override
  Stream<List<UserMessage>> userMessages(String restaurantId, String uid, String toRole) => _service.collectionStream(
    path: APIPath.messages(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
                          .where('toUid', isEqualTo: uid)
                          .where('toRole', isEqualTo: toRole)
        : null,
    builder: (data, documentId) => UserMessage.fromMap(data, documentId),
  );

  // Used to listen to messages sent to user
  @override
  Stream<UserMessage> userMessage(String uid) => _service.documentStream(
    path: APIPath.message(uid),
    builder: (data, documentId) => UserMessage.fromMap(data, documentId),
  );

  // Used by nearest restaurant query
  @override
  Future<List<Restaurant>> patronRestaurants() => _service.collectionSnapshot(
    path: APIPath.restaurants(),
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  // Used when saving restaurant details
  @override
  Future<void> setRestaurant(Restaurant restaurant) async => await _service
      .setData(path: APIPath.restaurant(restaurant.id), data: restaurant.toMap());

  // Used when saving message details
  @override
  Future<void> setMessageDetails(UserMessage message) async => await _service
      .setData(path: APIPath.message(message.id), data: message.toMap());

  // Used when saving authorizations
  @override
  Future<void> setAuthorization(String restaurantId, Authorizations authorizations) async => await _service
      .setData(path: APIPath.authorization(restaurantId), data: authorizations.toMap());

  @override
  Future<void> deleteMessage(String id) async =>
      await _service.deleteData(path: APIPath.message(id));

  @override
  Future<void> deleteRestaurant(Restaurant restaurant) async {
    await _service.deleteData(path: APIPath.restaurant(restaurant.id));
    await _service.deleteData(path: APIPath.authorization(restaurant.id));
  }

  @override
  Future<void> setMenu(Menu menu) async => await _service
      .setData(path: APIPath.menu(menu.id), data: menu.toMap());

  // Used by menu details page
  @override
  Stream<List<Menu>> restaurantMenus(String restaurantId) => _service.collectionStream(
    path: APIPath.menus(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Menu.fromMap(data, documentId),
  );

  @override
  Future<void> deleteMenu(Menu menu) async {
    await _service.deleteData(path: APIPath.menu(menu.id));
  }

  @override
  Future<void> setMenuItem(MenuItem item) async => await _service
      .setData(path: APIPath.menuItem(item.id), data: item.toMap());

  // Used by menu details page
  @override
  Stream<List<MenuItem>> menuItems(String menuId) => _service.collectionStream(
    path: APIPath.menuItems(),
    queryBuilder: menuId != null
        ? (query) => query.where('menuId', isEqualTo: menuId)
        : null,
    builder: (data, documentId) => MenuItem.fromMap(data, documentId),
  );

  @override
  Future<void> deleteMenuItem(MenuItem item) async {
    await _service.deleteData(path: APIPath.menuItem(item.id));
  }

  @override
  Future<void> setOption(Option option) async => await _service
      .setData(path: APIPath.option(option.id), data: option.toMap());

  // Used by option details page
  @override
  Stream<List<Option>> restaurantOptions(String restaurantId) => _service.collectionStream(
    path: APIPath.options(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Option.fromMap(data, documentId),
  );

  @override
  Future<void> deleteOption(Option option) async {
    await _service.deleteData(path: APIPath.option(option.id));
  }

  @override
  Future<void> setOptionItem(OptionItem optionItem) async => await _service
      .setData(path: APIPath.optionItem(optionItem.id), data: optionItem.toMap());

  // Used by option details page
  @override
  Stream<List<OptionItem>> optionItems(String optionId) => _service.collectionStream(
    path: APIPath.optionItems(),
    queryBuilder: optionId != null
        ? (query) => query.where('optionId', isEqualTo: optionId)
        : null,
    builder: (data, documentId) => OptionItem.fromMap(data, documentId),
  );

  @override
  Future<void> deleteOptionItem(OptionItem optionItem) async {
    await _service.deleteData(path: APIPath.optionItem(optionItem.id));
  }

  @override
  Future<void> setOrder(Order order) async => await _service
      .setData(path: APIPath.order(order.id), data: order.toMap());

  @override
  Stream<List<Order>> restaurantOrders(String restaurantId) => _service.collectionStream(
    path: APIPath.orders(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Order.fromMap(data, documentId),
  );

  @override
  Future<void> deleteOrder(Order order) async {
    await _service.deleteData(path: APIPath.order(order.id));
  }

  @override
  Stream<List<Order>> userOrders(String restaurantId, String uid) => _service.collectionStream(
    path: APIPath.orders(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
                          .where('userId', isEqualTo: uid)
        : null,
    builder: (data, documentId) => Order.fromMap(data, documentId),
  );

}
