import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_container.dart';
import 'package:nearbymenus/app/pages/orders/place_order_dialog.dart';

class ExpandableListView extends StatefulWidget {
  final Map<String, dynamic> menu;
  final Map<String, dynamic> options;

  const ExpandableListView({Key key, this.menu, this.options}) : super(key: key);

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  Map<String, dynamic> items;
  bool expandItemsFlag = false;
  var itemList;
  List<String> itemKeys = List<String>();
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Map<String, dynamic> get menu => widget.menu;

  @override
  Widget build(BuildContext context) {
    itemKeys.clear();
    final itemCount = menu.entries.where((element) {
      if (element.key.toString().length > 20) {
        itemKeys.add(element.key.toString());
        return true;
      } else {
        return false;
      }
    }).toList().length;
    if (itemCount == 0) {
      return Container();
    }
    final key = menu.keys.firstWhere((element) => element.toString().length > 20);
    items = menu[key];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(12.0),
            child: ListTile(
              isThreeLine: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menu['name'],
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  menu['notes'],
                ),
              ),
              trailing: IconButton(
                icon: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      expandItemsFlag ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    expandItemsFlag = !expandItemsFlag;
                  });
                }),
            ),
          ),
          ExpandableContainer(
            expanded: expandItemsFlag,
            expandedHeight: 90.0 * itemCount,
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 90.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                      width: 0.5,
                      color: Colors.orangeAccent,
                      ),
                      //color: Colors.grey,
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${menu[itemKeys[index]]['name']}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        '${menu[itemKeys[index]]['description']}',
                      ),
                    ),
                    trailing: Text(
                      f.format(menu[itemKeys[index]]['price']),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          fullscreenDialog: false,
                          builder: (context) => PlaceOrderDialog(
                            item: menu[itemKeys[index]],
                            options: widget.options,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
