import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class CupertinoHomeScaffoldPatron extends StatelessWidget {
  const CupertinoHomeScaffoldPatron({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItemPatron currentTab;
  final ValueChanged<TabItemPatron> onSelectTab;
  final Map<TabItemPatron, WidgetBuilder> widgetBuilders;
  final Map<TabItemPatron, GlobalKey<NavigatorState>> navigatorKeys;

  List<BottomNavigationBarItem> _itemsForRole(BuildContext context) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
          items.add(_buildItem(context, TabItemPatron.browseMenu));
          items.add(_buildItem(context, TabItemPatron.myOrders));
          items.add(_buildItem(context, TabItemPatron.userAccount));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).backgroundColor,
        activeColor: Theme.of(context).accentColor,
        items: _itemsForRole(context),
        onTap: (index) => onSelectTab(TabItemPatron.values[index]),
      ),
      resizeToAvoidBottomInset: false,
      tabBuilder: (context, index) {
        final item = TabItemPatron.values[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item](context),
          navigatorKey: navigatorKeys[item],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, TabItemPatron tabItem) {
    final itemData = TabItemData.allTabsPatron[tabItem];
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
