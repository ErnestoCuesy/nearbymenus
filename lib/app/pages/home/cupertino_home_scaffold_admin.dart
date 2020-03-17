import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class CupertinoHomeScaffoldAdmin extends StatelessWidget {
  const CupertinoHomeScaffoldAdmin({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItemAdmin currentTab;
  final ValueChanged<TabItemAdmin> onSelectTab;
  final Map<TabItemAdmin, WidgetBuilder> widgetBuilders;
  final Map<TabItemAdmin, GlobalKey<NavigatorState>> navigatorKeys;

  List<BottomNavigationBarItem> _itemsForRole(BuildContext context) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
          items.add(_buildItem(context, TabItemAdmin.maintainRestaurants));
          items.add(_buildItem(context, TabItemAdmin.maintainMenu));
          items.add(_buildItem(context, TabItemAdmin.manageOrders));
          items.add(_buildItem(context, TabItemAdmin.userAccount));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).backgroundColor,
        activeColor: Theme.of(context).accentColor,
        items: _itemsForRole(context),
        onTap: (index) => onSelectTab(TabItemAdmin.values[index]),
      ),
      resizeToAvoidBottomInset: false,
      tabBuilder: (context, index) {
        final item = TabItemAdmin.values[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item](context),
          navigatorKey: navigatorKeys[item],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, TabItemAdmin tabItem) {
    final itemData = TabItemData.allTabsAdmin[tabItem];
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
