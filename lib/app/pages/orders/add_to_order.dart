import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
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
      quantity: 1,
      price: item['price'],
      total: item['total'],
      options: menuItemOptions,
    ).toMap();
    session.currentOrder.orderItems.add(orderItem);
    print(orderItem);
    this.widget.callBack();
  }

  Widget _buildContents(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          color: Theme.of(context).dialogBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '${widget.item['name']}',
                    style: Theme.of(context).accentTextTheme.headline4,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '${widget.item['description']}',
                    //style: Theme.of(context).accentTextTheme.headline5,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    children: _buildOptions(),
                  ),
                  Text(
                    f.format(widget.item['price']),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FormSubmitButton(
                    context: context,
                    text: 'Add to order',
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      _addMenuItemToOrder();
                      Navigator.of(context).pop();
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
            onChanged: (addFlag) => _updateOptionsList('${optionValue['name']}: ${value['name']}', addFlag),
          ),
          );
        }
      });
    });
    return optionList;
  }

  void _updateOptionsList(String option, bool addFlag) {
    menuItemOptions.clear();
    setState(() {
      if (addFlag) {
        menuItemOptions.add(option);
      } else {
        menuItemOptions.remove(option);
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
