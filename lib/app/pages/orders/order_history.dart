import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/order_counter.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/orders/view_order.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/utilities/format.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  final bool showBlocked;

  const OrderHistory({Key key, this.showBlocked}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  Stream<List<Order>> stream;
  List<Order> blockedOrders;

  Widget _buildContents(BuildContext context) {
    stream = database.userOrders(
      session.nearestRestaurant.id,
      database.userId,
    );
    if (session.userDetails.role != ROLE_PATRON) {
      stream = database.restaurantOrders(
        session.nearestRestaurant.id,
      );
    }
    if (widget.showBlocked) {
      stream =  database.blockedOrders(database.userId);
    }
    return StreamBuilder<List<Order>>(
      stream: stream,
      builder: (context, snapshot) {
        blockedOrders = snapshot.data;
        return ListItemsBuilder<Order>(
            snapshot: snapshot,
            itemBuilder: (context, order) {
              return Card(
                color: session.userDetails.role != ROLE_PATRON && order.isBlocked ? Colors.redAccent : Theme.of(context).canvasColor,
                margin: EdgeInsets.all(12.0),
                child: ListTile(
                  isThreeLine: true,
                  leading: session.userDetails.role != ROLE_PATRON && order.isBlocked ? Icon(Icons.lock) : Icon(Icons.receipt),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order # ${order.orderNumber}',
                            style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          '${order.orderItems.length} items',
                          //style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: Text(
                            Format.formatDateTime(order.timestamp.toInt()),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            order.statusString,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Text(
                    f.format(order.orderTotal),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onTap: session.userDetails.role != ROLE_PATRON && order.isBlocked ? null : () => _viewOrder(context, order),
                ),
              );
            });
      },
    );
  }

  void _viewOrder(BuildContext context, Order order) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false,
          builder: (context) => ViewOrder(order: order,)
      ),
    );
  }

  Future<void> _unlockOrders() async {
    OrderCounter orderCounter = OrderCounter(ordersLeft: 0, lastUpdated: '');
    await database.ordersLeft(database.userId).then((value) {
      if (value != null) {
        orderCounter = value;
      }
    }).catchError((_) => null);
    print('Blocked orders: ${blockedOrders.length}');
    if (orderCounter.ordersLeft > blockedOrders.length) {
      blockedOrders.forEach((order) {
        order.isBlocked = false;
        database.setOrder(order);
      });
    } else {
        await PlatformExceptionAlertDialog(
            title: 'Order bundle depleted',
            exception: PlatformException(
            code: 'ORDER_BUNDLED_IS_DEPLETED',
            message:  'Please buy more order bundles from your profile page.',
            details:  'Please buy more order bundles from your profile page.',
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.showBlocked ? 'Locked orders' : 'Orders',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        actions: [
          if (widget.showBlocked)
          Padding(
            padding: const EdgeInsets.only(right: 26.0),
            child: IconButton(
              iconSize: 24.0,
              icon: Icon(Icons.lock_open),
              onPressed: () => _unlockOrders(),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }
}
