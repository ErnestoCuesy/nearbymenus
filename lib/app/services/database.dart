import 'dart:async';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/menu_item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/option.dart';
import 'package:nearbymenus/app/models/option_item.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/bundle.dart';
import 'package:nearbymenus/app/models/user_message.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  String get userId;
  void setUserId(String uid);

  Future<void> setUserDetails(UserDetails userDetails);
  Future<void> setRestaurant(Restaurant restaurant);
  Future<void> setMessageDetails(UserMessage roleNotification);
  Future<void> setAuthorization(String restaurantId, Authorizations authorizations);
  Future<void> setMenu(Menu menu);
  Future<void> setMenuItem(MenuItem menuItem);
  Future<void> setOption(Option option);
  Future<void> setOptionItem(OptionItem optionItem);
  Future<void> setOrder(Order order);
  Future<void> setBundle(String uid, Bundle orderBundle);
  Future<int>  setBundleCounterTransaction(String managerId, int quantity);
  Future<void> setOrderTransaction(String managerId, String restaurantId, Order order);

  Future<void> deleteMessage(String id);
  Future<void> deleteRestaurant(Restaurant restaurant);
  Future<void> deleteMenu(Menu menu);
  Future<void> deleteMenuItem(MenuItem menuItem);
  Future<void> deleteOption(Option option);
  Future<void> deleteOptionItem(OptionItem optionItem);
  Future<void> deleteOrder(Order order);

  Stream<UserDetails> userDetailsStream();
  Stream<Authorizations> authorizationsStream(String restaurantId);
  Stream<List<Restaurant>> managerRestaurants(String restaurantId);
  Stream<List<UserMessage>> managerMessages(String uid, String toRole);
  Stream<List<UserMessage>> staffMessages(String restaurantId, String toRole);
  Stream<List<UserMessage>> patronMessages(String restaurantId, String uid);
  Stream<List<Restaurant>> patronRestaurants();
  Stream<List<Menu>> restaurantMenus(String restaurantId);
  Stream<List<MenuItem>> menuItems(String menuItemId);
  Stream<List<Option>> restaurantOptions(String restaurantId);
  Stream<List<OptionItem>> optionItems(String optionId);
  Stream<List<Order>> restaurantOrders(String restaurantId);
  Stream<List<Order>> userOrders(String restaurantId, String uid);
  Stream<List<Order>> blockedOrders(String managerId);

  Future<UserDetails> userDetailsSnapshot(String uid);
  Future<List<Authorizations>> authorizationsSnapshot();
  Future<int> ordersLeft(String uid);
  Future<List<Bundle>> bundlesSnapshot(String managerId);
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

  @override
  Future<void> setUserDetails(UserDetails userDetails) async => await _service
      .setData(path: APIPath.userDetails(uid), data: userDetails.toMap());

  @override
  Future<void> setRestaurant(Restaurant restaurant) async => await _service
      .setData(path: APIPath.restaurant(restaurant.id), data: restaurant.toMap());

  @override
  Future<void> setMessageDetails(UserMessage message) async => await _service
      .setData(path: APIPath.message(message.id), data: message.toMap());

  @override
  Future<void> setAuthorization(String restaurantId, Authorizations authorizations) async => await _service
      .setData(path: APIPath.authorization(restaurantId), data: authorizations.toMap());

  @override
  Future<void> setMenu(Menu menu) async => await _service
      .setData(path: APIPath.menu(menu.id), data: menu.toMap());

  @override
  Future<void> setMenuItem(MenuItem item) async => await _service
      .setData(path: APIPath.menuItem(item.id), data: item.toMap());

  @override
  Future<void> setOption(Option option) async => await _service
      .setData(path: APIPath.option(option.id), data: option.toMap());

  @override
  Future<void> setOptionItem(OptionItem optionItem) async => await _service
      .setData(path: APIPath.optionItem(optionItem.id), data: optionItem.toMap());

  @override
  Future<void> setOrder(Order order) async => await _service
      .setData(path: APIPath.order(order.id), data: order.toMap());

  @override
  Future<void> setBundle(String managerUid, Bundle orderBundle) async => await _service
      .setData(path: APIPath.bundle(managerUid, orderBundle.id), data: orderBundle.toMap());

  @override
  Future<int> setBundleCounterTransaction(String managerId, int quantity) async {
    return await _service
        .runUpdateCounterTransaction(
        counterPath: APIPath.bundles(managerId),
        documentId: 'counter',
        fieldName: 'ordersLeft',
        quantity: quantity);
  }

  @override
  Future<void> setOrderTransaction(String managerId, String restaurantId, Order order) async {
    await _service.runSetOrderTransaction(
      orderNumberPath: APIPath.orderNumberCounter(),
      orderNumberDocumentId: restaurantId,
      orderNumberFieldName: 'lastOrderNumber',
      bundleCounterPath: APIPath.bundles(managerId),
      bundleCounterDocumentId: 'counter',
      bundleCounterFieldName: 'ordersLeft',
      orderPath: APIPath.orders(),
      orderDocumentId: order.id,
      orderData: order.toMap(),
    );
  }

  @override
  Future<void> deleteMessage(String id) async =>
      await _service.deleteData(path: APIPath.message(id));

  @override
  Future<void> deleteRestaurant(Restaurant restaurant) async {
    await _service.deleteData(path: APIPath.restaurant(restaurant.id));
    await _service.deleteData(path: APIPath.authorization(restaurant.id));
  }

  @override
  Future<void> deleteMenu(Menu menu) async {
    await _service.deleteData(path: APIPath.menu(menu.id));
  }

  @override
  Future<void> deleteMenuItem(MenuItem item) async {
    await _service.deleteData(path: APIPath.menuItem(item.id));
  }

  @override
  Future<void> deleteOption(Option option) async {
    await _service.deleteData(path: APIPath.option(option.id));
  }

  @override
  Future<void> deleteOptionItem(OptionItem optionItem) async {
    await _service.deleteData(path: APIPath.optionItem(optionItem.id));
  }

  @override
  Future<void> deleteOrder(Order order) async {
    await _service.deleteData(path: APIPath.order(order.id));
  }

  @override
  Stream<UserDetails> userDetailsStream() => _service.documentStream(
        path: APIPath.userDetails(uid),
        builder: (data, documentId) => UserDetails.fromMap(data),
      );

  @override
  Stream<Authorizations> authorizationsStream(String restaurantId) => _service.documentStream(
    path: APIPath.authorization(restaurantId),
    builder: (data, documentId) => Authorizations.fromMap(data, documentId),
  );

  @override
  Stream<List<Restaurant>> managerRestaurants(String managerId) => _service.collectionStream(
    path: APIPath.restaurants(),
    queryBuilder: managerId != null
          ? (query) => query.where('managerId', isEqualTo: managerId)
          : null,
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  @override
  Stream<List<UserMessage>> managerMessages(String uid, String toRole) => _service.collectionStream(
    path: APIPath.messages(),
    queryBuilder: uid != null
        ? (query) => query.where('toUid', isEqualTo: uid)
                          .where('toRole', isEqualTo: toRole)
        : null,
    builder: (data, documentId) => UserMessage.fromMap(data, documentId),
  );

  @override
  Stream<List<UserMessage>> staffMessages(String restaurantId, String toRole) => _service.collectionStream(
    path: APIPath.messages(),
    queryBuilder: uid != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        .where('toRole', isEqualTo: toRole)
        : null,
    builder: (data, documentId) => UserMessage.fromMap(data, documentId),
  );

  @override
  Stream<List<UserMessage>> patronMessages(String restaurantId, String uid) => _service.collectionStream(
    path: APIPath.messages(),
    queryBuilder: uid != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        .where('toUid', isEqualTo: uid)
        : null,
    builder: (data, documentId) => UserMessage.fromMap(data, documentId),
  );

  @override
  Stream<List<Restaurant>> patronRestaurants() => _service.collectionStream(
    path: APIPath.restaurants(),
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  @override
  Stream<List<Menu>> restaurantMenus(String restaurantId) => _service.collectionStream(
    path: APIPath.menus(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Menu.fromMap(data, documentId),
  );

  @override
  Stream<List<MenuItem>> menuItems(String menuId) => _service.collectionStream(
    path: APIPath.menuItems(),
    queryBuilder: menuId != null
        ? (query) => query.where('menuId', isEqualTo: menuId)
        : null,
    builder: (data, documentId) => MenuItem.fromMap(data, documentId),
  );

  @override
  Stream<List<Option>> restaurantOptions(String restaurantId) => _service.collectionStream(
    path: APIPath.options(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Option.fromMap(data, documentId),
  );

  @override
  Stream<List<OptionItem>> optionItems(String optionId) => _service.collectionStream(
    path: APIPath.optionItems(),
    queryBuilder: optionId != null
        ? (query) => query.where('optionId', isEqualTo: optionId)
        : null,
    builder: (data, documentId) => OptionItem.fromMap(data, documentId),
  );

  @override
  Stream<List<Order>> restaurantOrders(String restaurantId) => _service.collectionStream(
    path: APIPath.orders(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
        : null,
    builder: (data, documentId) => Order.fromMap(data, documentId),
  );

  @override
  Stream<List<Order>> userOrders(String restaurantId, String uid) => _service.collectionStream(
    path: APIPath.orders(),
    queryBuilder: restaurantId != null
        ? (query) => query.where('restaurantId', isEqualTo: restaurantId)
                          .where('userId', isEqualTo: uid)
        : null,
    builder: (data, documentId) => Order.fromMap(data, documentId),
  );

  @override
  Stream<List<Order>> blockedOrders(String managerId) => _service.collectionStream(
    path: APIPath.orders(),
    queryBuilder: managerId != null
        ? (query) => query.where('managerId', isEqualTo: managerId)
                          .where('isBlocked', isEqualTo: true)
        : null,
    builder: (data, documentId) => Order.fromMap(data, documentId),
  );

  @override
  Future<UserDetails> userDetailsSnapshot(String uid) => _service.documentSnapshot(
    path: APIPath.userDetails(uid),
    builder: (data, documentId) => UserDetails.fromMap(data),
  );

  @override
  Future<List<Authorizations>> authorizationsSnapshot() => _service.collectionSnapshot(
    path: APIPath.authorizations(),
    builder: (data, documentId) => Authorizations.fromMap(data, documentId),
  );

  @override
  Future<int> ordersLeft(String managerUid) => _service.documentSnapshot(
    path: APIPath.bundleOrdersCounter(managerUid),
    builder: (data, documentId) => data['ordersLeft'],
  );

  @override
  Future<List<Bundle>> bundlesSnapshot(String managerId) => _service.collectionSnapshot(
    path: APIPath.bundles(managerId),
    builder: (data, documentId) => Bundle.fromMap(data, documentId),
  );

}
