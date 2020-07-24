
class APIPath {
  static String userDetails(String uid) => 'users/$uid/';
  static String restaurant(String restaurantId) => 'restaurants/$restaurantId';
  static String restaurants() => 'restaurants';
  static String messages() => 'messages';
  static String message(String id) => 'messages/$id';
  static String authorization(String restaurantId) => 'authorizations/$restaurantId';
  static String authorizations() => 'authorizations';
  static String menu(String menuId) => 'menus/$menuId';
  static String menus() => 'menus';
  static String menuItem(String menuItemId) => 'menuItems/$menuItemId';
  static String menuItems() => 'menuItems';
  static String option(String optionId) => 'options/$optionId';
  static String options() => 'options';
  static String optionItem(String optionId) => 'optionItems/$optionId';
  static String optionItems() => 'optionItems';
  static String order(String orderId) => 'orders/$orderId';
  static String orders() => 'orders';
  static String orderNumberCounter() => 'orderNumbers';
  static String bundle(String managerId, String bundleId) => 'bundles/$managerId/bundles/$bundleId';
  static String bundles(String managerId) => 'bundles/$managerId/bundles';
  static String bundleOrdersCounter(String managerId) => 'bundles/$managerId/bundles/counter';
  static String itemImage(String restaurantId, String itemImageId) => 'itemImages/$restaurantId/images/$itemImageId';
  static String itemImages(String restaurantId) => 'itemImages/$restaurantId/images';
}