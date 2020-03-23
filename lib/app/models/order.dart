import 'package:meta/meta.dart';
import 'package:nearbymenus/app/models/menu_item.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'address.dart';

class Order {
  final int orderNumber;
  final UserAuth user;
  final Address deliveryAddress;
  final List<MenuItem> orderItems;

  Order(this.orderNumber, this.user, this.deliveryAddress, this.orderItems);
}
