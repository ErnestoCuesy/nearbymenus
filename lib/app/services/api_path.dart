
class APIPath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) => 'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  // TODO cleanup above unused definitions
  static String userDetails(String uid) => 'users/$uid/';
  static String restaurant(String restaurantId) => 'restaurants/$restaurantId';
  static String restaurants() => 'restaurants';
  static String messages() => 'messages';
  static String message(String id) => 'messages/$id';
  static String authorization(String restaurantId) => 'authorizations/$restaurantId';
  static String authorizations() => 'authorizations';
  static String menu(String menuId) => 'menus/$menuId';
  static String menus() => 'menus';
  static String item(String itemId) => 'items/$itemId';
  static String items() => 'items';
}