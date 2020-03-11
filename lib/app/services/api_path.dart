import 'package:nearbymenus/app/config/flavour_config.dart';

class APIPath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) => 'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  static String userDetails(String uid) => 'users/$uid/details/$uid'; // Repeat uid to add an even number of paths, otherwise throws error
}