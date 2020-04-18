import 'package:nearbymenus/app/config/flavour_config.dart';

class APIPath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) => 'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  // TODO cleanup above unused definitions
  static String userDetails(String uid) => 'users/$uid/';
  static String restaurant(String restaurantId) => 'restaurants/$restaurantId';
  static String restaurants() => 'restaurants';
  static String notifications() => 'notifications';
  static String notification(String id) => 'notifications/$id';
  static String authorization(String restaurantId) => 'authorizations/$restaurantId';
}