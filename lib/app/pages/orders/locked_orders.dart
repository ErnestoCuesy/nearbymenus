import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/orders/order_history.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class LockedOrders extends StatefulWidget {
  @override
  _LockedOrdersState createState() => _LockedOrdersState();
}

class _LockedOrdersState extends State<LockedOrders> {
  Session session;
  Database database;

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    return OrderHistory(
      stream: database.blockedOrders(database.userId),
      restaurantName: session.currentRestaurant.name,
      showLocked: true,
      showActive: true,
    );
  }
}