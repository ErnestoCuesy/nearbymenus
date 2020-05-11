import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/order_item.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class AddToOrder extends StatefulWidget {
  final Function callBack;
  final Map<String, dynamic> item;
  final Map<String, dynamic> options;

  const AddToOrder({Key key, this.callBack, this.item, this.options}) : super(key: key);

  @override
  _AddToOrderState createState() => _AddToOrderState();
}

class _AddToOrderState extends State<AddToOrder> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  List<String> itemKeys = List<String>();
  Map<String, dynamic> get item => widget.item;
  List<String> menuItemOptions = List<String>();
  Map<String, int> optionsSelectionCounters = Map<String, int>();
  int quantity = 1;
  double lineTotal = 0;

  void _addMenuItemToOrder() {
    final double timestamp = dateFromCurrentDate() / 1.0;
    var orderNumber = documentIdFromCurrentDate();
    if (session.currentOrder == null) {
      session.currentOrder = Order(
        id: orderNumber,
        restaurantId: session.nearestRestaurant.id,
        userId: database.userId,
        timestamp: timestamp,
        status: ORDER_ON_HOLD,
        name: session.userDetails.name,
        deliveryAddress: '${session.userDetails.address} ${session.nearestRestaurant.restaurantLocation}',
        orderItems: List<Map<String, dynamic>>(),
      );
    } else {
      orderNumber = session.currentOrder.id;
    }
    final orderItem = OrderItem(
      id: documentIdFromCurrentDate(),
      orderId: orderNumber,
      name: item['name'],
      quantity: quantity,
      price: item['price'],
      lineTotal: lineTotal,
      options: menuItemOptions,
    ).toMap();
    session.currentOrder.orderItems.add(orderItem);
    print(orderItem);
    this.widget.callBack();
  }

  Widget _buildContents(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    lineTotal = widget.item['price'] * quantity;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 24.0,
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
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Text(
                      '${widget.item['name']}',
                      style: Theme.of(context).accentTextTheme.headline4,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(
                      '${widget.item['description']}',
                      //style: Theme.of(context).accentTextTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  if (widget.item['options'].isNotEmpty)
                  Column(
                    children: _buildOptions(),
                  ),
                  if (widget.item['options'].isEmpty)
                    Column(
                      children: _buildQuantityField(),
                    ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    f.format(lineTotal),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FormSubmitButton(
                    context: context,
                    text: 'Add to order',
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_optionsAreValid()) {
                        _addMenuItemToOrder();
                        Navigator.of(context).pop();
                      } else {
                        await PlatformExceptionAlertDialog(
                          title: 'Incorrect number of options selected',
                          exception: PlatformException(
                            code: 'INCORRECT_OPTIONS',
                            message:  'Please check your choices.',
                            details:  'Please check your choices.',
                          ),
                        ).show(context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQuantityField() {
    return [
      new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.remove),
              onPressed: quantity == 1 ? null : () {
                setState(() {
                  quantity--;
                });
              },
            ),
            new Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Colors.grey[700],
                  width: 0.5,
                ),
              ),
              child: new SizedBox(
                width: 70.0,
                height: 45.0,
                child: new Center(
                    child: new Text('$quantity',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center)),
              ),
            ),
            new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
            ),
          ],
        ),
      ),
    ];
  }

  bool _optionsAreValid() {
    if (widget.item['options'].isEmpty) {
      return true;
    }
    if (optionsSelectionCounters.isEmpty) {
      return false;
    }
    bool optionsAreValid = true;
    widget.item['options'].forEach((key) {
      Map<String, dynamic> optionValue = widget.options[key];
      final maxAllowed = optionValue['numberAllowed'];
      if (optionsSelectionCounters[optionValue['name']] == null ||
          optionsSelectionCounters[optionValue['name']] > maxAllowed ||
          optionsSelectionCounters[optionValue['name']] == 0) {
        optionsAreValid = false;
      }
    });
    return optionsAreValid;
  }

  List<Widget> _buildOptions() {
    List<Widget> optionList = List<Widget>();
    widget.item['options'].forEach((key) {
      Map<String, dynamic> optionValue = widget.options[key];
      optionList.add(
        Text(
          '${optionValue['name']}',
          style: Theme.of(context).accentTextTheme.headline5,
        ),
      );
      var selectionNote;
      var singular = '';
      if (optionValue['numberAllowed'] > 1) {
        selectionNote = 'up to';
        singular = 's';
      } else {
        selectionNote = 'only';
      }
      optionList.add(SizedBox(height: 8.0,));
      optionList.add(
        Text(
          'Please select $selectionNote ${optionValue['numberAllowed']} option$singular',
        ),
      );
      optionValue.forEach((key, value) {
        if (key.toString().length > 20) {
            optionList.add(CheckboxListTile(
              title: Text(
                '${value['name']}',
              ),
              value: optionCheck('${optionValue['name']}: ${value['name']}'),
              onChanged: (addFlag) => _updateOptionsList(optionValue['name'], '${optionValue['name']}: ${value['name']}', addFlag),
            ),
          );
        }
      });
    });
    return optionList;
  }

  void _updateOptionsList(String key, String option, bool addFlag) {
    setState(() {
      if (addFlag) {
        menuItemOptions.add(option);
        if (optionsSelectionCounters.containsKey(key)) {
          optionsSelectionCounters.update(key, (value) => value + 1);
        } else {
          optionsSelectionCounters.putIfAbsent(key, () => 1);
        }
      } else {
        menuItemOptions.remove(option);
        if (optionsSelectionCounters.containsKey(key)) {
          optionsSelectionCounters.update(key, (value) => value - 1);
        } else {
          optionsSelectionCounters.putIfAbsent(key, () => 0);
        }
      }
    });
  }

  bool optionCheck(String key) => menuItemOptions.contains(key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select your options',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
      ),
      body: _buildContents(context),
    );
  }
}
