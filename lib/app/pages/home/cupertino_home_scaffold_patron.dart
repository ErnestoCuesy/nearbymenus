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
    @required this.roleTabItems,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;
  final RoleEnumBase roleTabItems;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).backgroundColor,
        activeColor: Theme.of(context).accentColor,
        items: RoleEnumBase.itemsForRole(context, currentTab, roleTabItems),
        onTap: (index) => onSelectTab(roleTabItems.roleEnumList[index]),
      ),
      resizeToAvoidBottomInset: false,
      tabBuilder: (context, index) {
        final item = roleTabItems.roleEnumList[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item](context),
          navigatorKey: navigatorKeys[item],
        );
      },
    );
  }

}
