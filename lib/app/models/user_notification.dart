import 'package:meta/meta.dart';

class UserNotification {
  final String id;
  final String fromUid;
  final String toUid;
  final String restaurantId;
  final String fromRole;
  final String toRole;
  final String fromName;
  final bool read;
  final String type;

  UserNotification({
    @required this.id,
    @required this.fromUid,
    @required this.toUid,
    @required this.restaurantId,
    @required this.fromRole,
    @required this.toRole,
    @required this.fromName,
    @required this.read,
    @required this.type,
  });

  factory UserNotification.fromMap(
      Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return UserNotification(
        id: data['id'],
        fromUid: data['fromUid'],
        toUid: data['toUid'],
        restaurantId: data['restaurantId'],
        fromRole: data['fromRole'],
        toRole: data['toRole'],
        fromName: data['fromName'],
        read: data['read'],
        type: data['type']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromUid': fromUid,
      'toUid': toUid,
      'restaurantId': restaurantId,
      'fromRole': fromRole,
      'toRole': toRole,
      'fromName': fromName,
      'read': read,
      'type': type
    };
  }

  @override
  String toString() {
    return 'id: $id, fromUid: $fromUid, toUid: $toUid, restaurantId: $restaurantId, fromRole: $fromRole, toRole: $toRole, fromName: $fromName, read: $read, type: $type';
  }
}
