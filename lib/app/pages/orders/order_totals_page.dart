import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/order.dart';

class OrderTotalsPage extends StatefulWidget {
  final Stream<List<Order>> stream;
  final String selectedStringDate;

  const OrderTotalsPage({Key key, this.stream, this.selectedStringDate}) : super(key: key);

  @override
  _OrderTotalsPageState createState() => _OrderTotalsPageState();
}

class _OrderTotalsPageState extends State<OrderTotalsPage> {
  List<Order> _orderList = List<Order>();
  Map<String, double> _orderTotals = {};
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  void _calculateTotals() {
    _orderTotals.clear();
    _orderTotals.putIfAbsent('active', () => 0.00);
    _orderTotals.putIfAbsent('closed', () => 0.00);
    _orderList.forEach((order) {
      if (order.status > ORDER_PLACED && order.status < 10) {
        _orderTotals.update('active', (value) => value + order.orderTotal);
      } else {
        if (order.status == ORDER_CLOSED) {
          _orderTotals.update('closed', (value) => value + order.orderTotal);
        }
      }
    });
    print('Orders totals: $_orderTotals');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting &&
            snapshot.hasData) {
          _orderList = snapshot.data;
          _calculateTotals();
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Sales for the day',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.selectedStringDate,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 300,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Orders in progress',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${f.format(_orderTotals['active'])}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 300,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Orders closed',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${f.format(_orderTotals['closed'])}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 300,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Total',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${f.format(_orderTotals['active'] +
                                    _orderTotals['closed'])}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: PlatformProgressIndicator(),
          );
        }
      },
    );
  }
}