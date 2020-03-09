import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meta/meta.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'enumerations.dart';


class Subscription {
  final SubscriptionStatus status;
  final Restaurant restaurant;
  final List<ProductDetails> products;
  final List<PurchaseDetails> purchases;

  Subscription(this.status, this.restaurant, this.products, this.purchases);
}