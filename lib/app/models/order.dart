import 'package:meta/meta.dart';
import 'package:nearbymenus/app/models/item.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'address.dart';

class Order {
  final int orderNumber;
  final UserAuth user;
  final Address deliveryAddress;
  final List<Item> orderItems;

  Order(this.orderNumber, this.user, this.deliveryAddress, this.orderItems);
}
