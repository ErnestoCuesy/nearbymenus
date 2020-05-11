import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  ScrollController scrollController = ScrollController();

  void _deleteOrderItem(int index) {
    setState(() {
      session.currentOrder.orderItems.removeAt(index);
    });
  }

  Future<bool> _confirmDismiss(BuildContext context) async {
    return await PlatformAlertDialog(
      title: 'Confirm order item deletion',
      content: 'Do you really want to delete this order item?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    ).show(context);
  }

  Widget _buildContents(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    final orderTotal = session.currentOrder.orderTotal;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 16.0,
          height: MediaQuery.of(context).size.height - 150.0,
          color: Theme.of(context).dialogBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24.0),
                    child: Text(
                      ' Deliver to:',
                      style: Theme.of(context).accentTextTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(session.currentOrder.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(session.currentOrder.deliveryAddress),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 500.0,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Scrollbar(
                        isAlwaysShown: true,
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: session.currentOrder.orderItems.length,
                          itemBuilder: (BuildContext context, int index) {
                          final orderItem = session.currentOrder.orderItems[index];
                          final List<String> orderItemOptions = orderItem['options'];
                          return Dismissible(
                            background: Container(color: Colors.red),
                            key: Key('${orderItem['id']}'),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) => _confirmDismiss(context),
                            onDismissed: (direction) => _deleteOrderItem(index),
                            child: Card(
                              child: ListTile(
                                isThreeLine: false,
                                leading: Text(
                                  orderItem['quantity'].toString(),
                                ),
                                title: Text(
                                  orderItem['name'],
                                ),
                                subtitle: orderItemOptions.isEmpty ? Text('') : Text(
                                  orderItem['options'].toString().replaceAll(RegExp(r'\[| \]'), ''),
                                ),
                                trailing: Text(
                                    f.format(orderItem['lineTotal'])
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Scroll to view more items. Swipe an item to the left to remove it. Tap an item to make changes.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Order total: ' + f.format(orderTotal),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FormSubmitButton(
                          context: context,
                          text: 'Cancel Order',
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                        ),
                        FormSubmitButton(
                          context: context,
                          text: 'Place Order',
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your order details',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
      ),
      body: _buildContents(context),
    );
  }
}
