import 'package:nearbymenus/app/config/flavour_config.dart';

class APIPath {
  static String job(String uid, String jobId) => '$dbRootCollection/users/$uid/jobs/$jobId';
  static String jobs(String uid) => '$dbRootCollection/users/$uid/jobs';
  static String entry(String uid, String entryId) => '$dbRootCollection/users/$uid/entries/$entryId';
  static String entries(String uid) => '$dbRootCollection/users/$uid/entries';
  static String userName(String uid, String userName) => 'users/$uid/details/$userName';
  static String userAddress(String uid, String userAddress) => 'users/$uid/details/$userAddress';
  static String userDetails(String uid) => 'users/$uid/details/$uid'; // Repeat uid to add an even number of paths, otherwise throws error
  static String dbRootCollection() => FlavourConfig.instance.values.dbRootCollection;
}