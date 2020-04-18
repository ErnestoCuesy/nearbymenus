import 'package:meta/meta.dart';

class UserMessage {
  final String id;
  final String fromUid;
  final String toUid;
  final String restaurantId;
  final String fromRole;
  final String toRole;
  final String fromName;
  final bool delivered;
  final String type;

  UserMessage({
    @required this.id,
    @required this.fromUid,
    @required this.toUid,
    @required this.restaurantId,
    @required this.fromRole,
    @required this.toRole,
    @required this.fromName,
    @required this.delivered,
    @required this.type,
  });

  factory UserMessage.fromMap(
      Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return UserMessage(
        id: data['id'],
        fromUid: data['fromUid'],
        toUid: data['toUid'],
        restaurantId: data['restaurantId'],
        fromRole: data['fromRole'],
        toRole: data['toRole'],
        fromName: data['fromName'],
        delivered: data['delivered'],
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
      'delivered': delivered,
      'type': type
    };
  }

  @override
  String toString() {
    return 'id: $id, fromUid: $fromUid, toUid: $toUid, restaurantId: $restaurantId, fromRole: $fromRole, toRole: $toRole, fromName: $fromName, delivered: $delivered, type: $type';
  }
}
