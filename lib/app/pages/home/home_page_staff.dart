import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/cupertino_home_scaffold_staff.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class HomePageStaff extends StatefulWidget {
  final UserDetails userDetails;

  const HomePageStaff({Key key, this.userDetails}) : super(key: key);

  @override
  _HomePageStaffState createState() => _HomePageStaffState();
}

class _HomePageStaffState extends State<HomePageStaff> {

  UserDetails get userDetails => widget.userDetails;
  TabItemStaff _currentTab = TabItemStaff.manageOrders;

  final Map<TabItemStaff, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItemStaff.manageOrders: GlobalKey<NavigatorState>(),
    TabItemStaff.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItemStaff, WidgetBuilder> get widgetBuilders {
    return {
      TabItemStaff.manageOrders: (_) => Placeholder(),
      TabItemStaff.userAccount: (_) => AccountPage()
    };
  }

  void _select(TabItemStaff tabItem) {
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
      child: CupertinoHomeScaffoldStaff(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
