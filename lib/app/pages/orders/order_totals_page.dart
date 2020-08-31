import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/pages/reports/item_breakdown_report.dart';

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
  Map<String, int> _paymentMethodQuantityTotals = {};
  Map<String, double> _paymentMethodAmountTotals = {};
  Map<String, double> _tipsAndDiscountsAmountTotals = {};
  Map<String, dynamic> _itemizedSubTotalPerStatus = {};
  Map<String, dynamic> _itemizedQuantityPerStatus = {};
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  void _updateSubTotalPerStatus(Order order, String status) {
    order.orderItems.forEach((item) {
      if (_itemizedSubTotalPerStatus[status].containsKey(item['name'])) {
        _itemizedSubTotalPerStatus[status].update(item['name'], (value) => value + item['lineTotal']);
        _itemizedQuantityPerStatus[status].update(item['name'], (value) => value + item['quantity']);
      } else {
        _itemizedSubTotalPerStatus[status].putIfAbsent(item['name'], () => item['lineTotal']);
        _itemizedQuantityPerStatus[status].putIfAbsent(item['name'], () => item['quantity']);
      }
    });
  }

  void _calculateTotals() {
    _orderTotals.clear();
    _itemizedQuantityPerStatus.clear();
    _itemizedSubTotalPerStatus.clear();
    _paymentMethodQuantityTotals.clear();
    _paymentMethodAmountTotals.clear();
    _tipsAndDiscountsAmountTotals.clear();
    for (String status in ['Pending', 'Cancelled', 'Rejected', 'Active', 'Closed']) {
      _orderTotals.putIfAbsent(status, () => 0.00);
      _itemizedSubTotalPerStatus.putIfAbsent(status, () => Map<String, dynamic>());
      _itemizedQuantityPerStatus.putIfAbsent(status, () => Map<String, dynamic>());
    }
    _tipsAndDiscountsAmountTotals.putIfAbsent('tips', () => 0);
    _tipsAndDiscountsAmountTotals.putIfAbsent('discounts', () => 0);
    _orderList.forEach((order) {
      if (order.status == ORDER_PLACED) {
        _orderTotals.update('Pending', (value) => value + order.orderTotal);
        _updateSubTotalPerStatus(order, 'Pending');
      } else if (order.status > ORDER_PLACED && order.status < 10) {
        _orderTotals.update('Active', (value) => value + order.orderTotal);
        _updateSubTotalPerStatus(order, 'Active');
      } else if (order.status == ORDER_REJECTED_BUSY || order.status == ORDER_REJECTED_STOCK) {
        _orderTotals.update('Rejected', (value) => value + order.orderTotal);
        _updateSubTotalPerStatus(order, 'Rejected');
      } else if (order.status == ORDER_CANCELLED) {
        _orderTotals.update('Cancelled', (value) => value + order.orderTotal);
        _updateSubTotalPerStatus(order, 'Cancelled');
      } else {
        if (order.status == ORDER_CLOSED) {
          final total = order.orderTotal - (order.orderTotal * order.discount) + order.tip;
          _orderTotals.update('Closed', (value) => value + total);
          _updateSubTotalPerStatus(order, 'Closed');
          if (_paymentMethodAmountTotals.containsKey(order.paymentMethod)) {
            _paymentMethodQuantityTotals.update(order.paymentMethod, (value) => value + 1);
            _paymentMethodAmountTotals.update(order.paymentMethod, (value) => value + total);
          } else {
            _paymentMethodQuantityTotals.putIfAbsent(order.paymentMethod, () => 1);
            _paymentMethodAmountTotals.putIfAbsent(order.paymentMethod, () => total);
          }
          _tipsAndDiscountsAmountTotals.update('tips', (value) => value + order.tip);
          _tipsAndDiscountsAmountTotals.update('discounts', (value) => value + (order.orderTotal * order.discount));
        }
      }
    });
  }

  Widget _totalCard(BuildContext context, String totalName, bool withPaymentMethod, bool withTipsAndDiscounts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: 300,
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  totalName,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${f.format(_orderTotals['$totalName'])}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.format_list_bulleted),
                    onPressed: () {
                      Navigator.of(context).push(ItemBreakdownReport(
                        amounts: _itemizedSubTotalPerStatus[totalName],
                        quantities: _itemizedQuantityPerStatus[totalName],
                      ));
                    },
                  ),
                  if (withPaymentMethod)
                  IconButton(
                    icon: Icon(Icons.payment),
                    onPressed: () {
                      Navigator.of(context).push(ItemBreakdownReport(
                        amounts: _paymentMethodAmountTotals,
                        quantities: _paymentMethodQuantityTotals,
                      ));
                    },
                  ),
                  if (withTipsAndDiscounts)
                    IconButton(
                      icon: Icon(Icons.monetization_on),
                      onPressed: () {
                        Navigator.of(context).push(ItemBreakdownReport(
                          amounts: _tipsAndDiscountsAmountTotals,
                          quantities: {'tips': 0, 'discounts': 0},
                        ));
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                      'Totals For The Day',
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
                  _totalCard(context, 'Closed', true, true),
                  _totalCard(context, 'Active', false, false),
                  _totalCard(context, 'Pending', false, false),
                  _totalCard(context, 'Cancelled', false, false),
                  _totalCard(context, 'Rejected', false, false),
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
