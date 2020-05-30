import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/user/account_page.dart';
import 'package:nearbymenus/app/pages/home/cupertino_home_scaffold.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_query.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class HomePageStaffAndPatron extends StatefulWidget {

  @override
  _HomePageStaffAndPatronState createState() => _HomePageStaffAndPatronState();
}

class _HomePageStaffAndPatronState extends State<HomePageStaffAndPatron> {

  AuthBase auth;
  Database database;

  TabItem _currentTab = TabItem.restaurant;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.restaurant: GlobalKey<NavigatorState>(),
    TabItem.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.restaurant: (_) => RestaurantQuery(),
      TabItem.userAccount: (_) => AccountPage()
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthBase>(context);
    database = Provider.of<Database>(context);
    return WillPopScope(
      onWillPop: () async =>  !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
        roleTabItems: RoleEnumBase.getRoleTabItems(),
      ),
    );
  }
}
