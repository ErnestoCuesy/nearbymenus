import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/utilities/format.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: database.userOrders(
        session.nearestRestaurant.id,
        database.userId,
      ),
      builder: (context, snapshot) {
        return ListItemsBuilder<Order>(
            snapshot: snapshot,
            itemBuilder: (context, order) {
              return Card(
                margin: EdgeInsets.all(12.0),
                child: ListTile(
                  isThreeLine: false,
                  leading: Icon(Icons.shopping_cart),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Text(
                            Format.formatDateTime(order.timestamp.toInt()),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 4.0, bottom: 4.0),
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
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders History',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
      ),
      body: _buildContents(context),
    );
  }
}
