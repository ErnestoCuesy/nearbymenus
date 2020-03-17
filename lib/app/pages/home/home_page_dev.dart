import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/cupertino_home_scaffold_dev.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class HomePageDev extends StatefulWidget {
  final UserDetails userDetails;

  const HomePageDev({Key key, this.userDetails}) : super(key: key);

  @override
  _HomePageDevState createState() => _HomePageDevState();
}

class _HomePageDevState extends State<HomePageDev> {

  UserDetails get userDetails => widget.userDetails;
  TabItemDev _currentTab = TabItemDev.maintainRestaurants;

  final Map<TabItemDev, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItemDev.maintainRestaurants: GlobalKey<NavigatorState>(),
    TabItemDev.browseMenu: GlobalKey<NavigatorState>(),
    TabItemDev.myOrders: GlobalKey<NavigatorState>(),
    TabItemDev.maintainMenu: GlobalKey<NavigatorState>(),
    TabItemDev.manageOrders: GlobalKey<NavigatorState>(),
    TabItemDev.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItemDev, WidgetBuilder> get widgetBuilders {
    return {
      TabItemDev.maintainRestaurants: (_) => Placeholder(),
      TabItemDev.browseMenu: (_) => Placeholder(),
      TabItemDev.myOrders: (_) => Placeholder(),
      TabItemDev.maintainMenu: (_) => Placeholder(),
      TabItemDev.manageOrders: (_) => Placeholder(),
      TabItemDev.userAccount: (_) => AccountPage()
    };
  }

  void _select(TabItemDev tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>  !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffoldDev(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
