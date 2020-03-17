import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';
import 'cupertino_home_scaffold_admin.dart';

class HomePageAdmin extends StatefulWidget {
  final UserDetails userDetails;

  const HomePageAdmin({Key key, this.userDetails}) : super(key: key);

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {

  UserDetails get userDetails => widget.userDetails;
  TabItemAdmin _currentTab = TabItemAdmin.maintainRestaurants;

  final Map<TabItemAdmin, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItemAdmin.maintainRestaurants: GlobalKey<NavigatorState>(),
    TabItemAdmin.maintainMenu: GlobalKey<NavigatorState>(),
    TabItemAdmin.manageOrders: GlobalKey<NavigatorState>(),
    TabItemAdmin.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItemAdmin, WidgetBuilder> get widgetBuilders {
    return {
      TabItemAdmin.maintainRestaurants: (_) => Placeholder(),
      TabItemAdmin.maintainMenu: (_) => Placeholder(),
      TabItemAdmin.manageOrders: (_) => Placeholder(),
      TabItemAdmin.userAccount: (_) => AccountPage()
    };
  }

  void _select(TabItemAdmin tabItem) {
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
      child: CupertinoHomeScaffoldAdmin(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
