import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class CupertinoHomeScaffoldStaff extends StatelessWidget {
  const CupertinoHomeScaffoldStaff({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItemStaff currentTab;
  final ValueChanged<TabItemStaff> onSelectTab;
  final Map<TabItemStaff, WidgetBuilder> widgetBuilders;
  final Map<TabItemStaff, GlobalKey<NavigatorState>> navigatorKeys;

  List<BottomNavigationBarItem> _itemsForRole(BuildContext context) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
          items.add(_buildItem(context, TabItemStaff.manageOrders));
          items.add(_buildItem(context, TabItemStaff.userAccount));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).backgroundColor,
        activeColor: Theme.of(context).accentColor,
        items: _itemsForRole(context),
        onTap: (index) => onSelectTab(TabItemStaff.values[index]),
      ),
      resizeToAvoidBottomInset: false,
      tabBuilder: (context, index) {
        final item = TabItemStaff.values[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item](context),
          navigatorKey: navigatorKeys[item],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, TabItemStaff tabItem) {
    final itemData = TabItemData.allTabsStaff[tabItem];
    final color = currentTab == tabItem
        ? Theme.of(context).tabBarTheme.labelColor
        : Theme.of(context).tabBarTheme.unselectedLabelColor;
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon),
      title: Text(
        itemData.title,
        style: TextStyle(color: color),
      ),
    );
  }
}
