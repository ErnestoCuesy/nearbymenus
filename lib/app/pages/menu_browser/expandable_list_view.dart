import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_container.dart';

class ExpandableListView extends StatefulWidget {
  final Map<String, dynamic> menu;

  const ExpandableListView({Key key, this.menu}) : super(key: key);

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  Map<String, dynamic> items;
  bool expandItemsFlag = false;
  var itemList;
  List<String> itemKeys = List<String>();

  Map<String, dynamic> get menu => widget.menu;

  int get itemCount {
    final count =  menu.entries.where((element) {
      if (element.key.toString().length > 20) {
        itemKeys.add(element.key.toString());
        return true;
      } else {
        return false;
      }
    }).toList().length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final itemsKey = menu.keys.firstWhere((element) => element.toString().length > 20);
    items = menu[itemsKey];
    print('>>>>>> Menu: ${menu['name']}');
    print('>>> Item: ${items['name']}');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  menu['name'],
                  style: TextStyle(fontWeight: FontWeight.bold,),
                ),
                IconButton(
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
              ],
            ),
          ),
          ExpandableContainer(
            expanded: expandItemsFlag,
            expandedHeight: 75.0 * itemCount,
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration:
                  BoxDecoration(border: Border.all(
                      width: 1.0, color: Colors.black),
                      color: Colors.grey),
                  child: ListTile(
                    title: Text(
                      '${menu[itemKeys[index]]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      '${menu[itemKeys[index]]['description']}',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    leading: Icon(
                      Icons.fastfood,
                      color: Colors.white,
                    ),
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
