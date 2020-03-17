import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class CupertinoHomeScaffoldDev extends StatelessWidget {
  const CupertinoHomeScaffoldDev({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItemDev currentTab;
  final ValueChanged<TabItemDev> onSelectTab;
  final Map<TabItemDev, WidgetBuilder> widgetBuilders;
  final Map<TabItemDev, GlobalKey<NavigatorState>> navigatorKeys;

  List<BottomNavigationBarItem> _itemsForRole(BuildContext context) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
          items.add(_buildItem(context, TabItemDev.maintainRestaurants));
          items.add(_buildItem(context, TabItemDev.maintainMenu));
          items.add(_buildItem(context, TabItemDev.manageOrders));
          items.add(_buildItem(context, TabItemDev.browseMenu));
          items.add(_buildItem(context, TabItemDev.myOrders));
          items.add(_buildItem(context, TabItemDev.userAccount));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).backgroundColor,
        activeColor: Theme.of(context).accentColor,
        items: _itemsForRole(context),
        onTap: (index) => onSelectTab(TabItemDev.values[index]),
      ),
      resizeToAvoidBottomInset: false,
      tabBuilder: (context, index) {
        final item = TabItemDev.values[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item](context),
          navigatorKey: navigatorKeys[item],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, TabItemDev tabItem) {
    final itemData = TabItemData.allTabsDev[tabItem];
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
