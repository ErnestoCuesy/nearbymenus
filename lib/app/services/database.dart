import 'dart:async';
import 'package:meta/meta.dart';
import 'package:nearbymenus/app/models/job.dart';
import 'package:nearbymenus/app/models/entry.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  String get userId;
  void setUserId(String uid);
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
  Stream<Job> jobStream({@required String jobId});

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
  Future<void> setUserDetails(UserDetails userDetails);
  Stream<UserDetails> userDetailsStream();
  Stream<List<Restaurant>> managerRestaurants(String restaurantId);
  Stream<List<Restaurant>> userRestaurant(String restaurantId);
  Stream<List<Restaurant>> restaurantsStream(String restaurantId);
  Future<List<Restaurant>> patronRestaurants();
  Stream<Restaurant> restaurantStream();
  Future<void> setRestaurantDetails(Restaurant restaurant);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

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
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Future<void> setUserDetails(UserDetails userDetails) async => await _service
      .setData(path: APIPath.userDetails(uid), data: userDetails.toMap());

  @override
  Stream<UserDetails> userDetailsStream() => _service.documentStream(
        path: APIPath.userDetails(uid),
        builder: (data, documentId) => UserDetails.fromMap(data),
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

  // Used by nearest restaurant query
  @override
  Future<List<Restaurant>> patronRestaurants() => _service.collectionSnapshot(
    path: APIPath.restaurants(),
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  // Used when saving restaurant details
  @override
  Future<void> setRestaurantDetails(Restaurant restaurant) async => await _service
      .setData(path: APIPath.restaurant(restaurant.id), data: restaurant.toMap());

  // Not used
  @override
  Stream<List<Restaurant>> restaurantsStream(String restaurantId) => _service.collectionStream(
    path: APIPath.restaurants(),
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

  // Not used
  @override
  Stream<Restaurant> restaurantStream() => _service.documentStream(
    path: APIPath.restaurants(),
    builder: (data, documentId) => Restaurant.fromMap(data, documentId),
  );

}
