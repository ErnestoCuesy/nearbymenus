class APIPath {
  static String userDetails(String uid) => 'users/$uid/';
  static String restaurant(String restaurantId) => 'restaurants/$restaurantId';
  static String restaurants() => 'restaurants';
  static String messages() => 'messages';
  static String message(String id) => 'messages/$id';
  static String authorization(String restaurantId) => 'authorizations/$restaurantId';
  static String authorizations() => 'authorizations';
  static String menu(String restaurantId, String menuId) => 'restaurants/$restaurantId/menus/$menuId';
  static String menus(String restaurantId) => 'restaurants/$restaurantId/menus';
  static String menuItem(String restaurantId, String menuItemId) => 'restaurants/$restaurantId/menuItems/$menuItemId';
  static String menuItems(String restaurantId) => 'restaurants/$restaurantId/menuItems';
  static String option(String restaurantId, String optionId) => 'restaurants/$restaurantId/options/$optionId';
  static String options(String restaurantId) => 'restaurants/$restaurantId/options';
  static String optionItem(String restaurantId, String optionId) => 'restaurants/$restaurantId/optionItems/$optionId';
  static String optionItems(String restaurantId) => 'restaurants/$restaurantId/optionItems';
  static String order(String orderId) => 'orders/$orderId';
  static String orders() => 'orders';
  static String orderNumberCounter(String restaurantId) => 'restaurants/$restaurantId/orderNumbers';
  static String bundle(String emailOrManagerId, String bundleId) => 'bundles/$emailOrManagerId/bundles/$bundleId';
  static String bundles(String emailOrManagerId) => 'bundles/$emailOrManagerId/bundles';
  static String bundleOrdersCounter(String managerId) => 'bundles/$managerId/bundles/counter';
  static String itemImage(String restaurantId, int itemImageId) => 'itemImages/$restaurantId/images/$itemImageId';
  static String itemImages(String restaurantId) => 'itemImages/$restaurantId/images';
  static String itemImg(String restaurantId) => 'itemImages/$restaurantId';
}