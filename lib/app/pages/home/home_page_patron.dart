import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/cupertino_home_scaffold_patron.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';

class HomePagePatron extends StatefulWidget {
  final UserDetails userDetails;

  const HomePagePatron({Key key, this.userDetails}) : super(key: key);

  @override
  _HomePagePatronState createState() => _HomePagePatronState();
}

class _HomePagePatronState extends State<HomePagePatron> {

  UserDetails get userDetails => widget.userDetails;
  TabItemPatron _currentTab = TabItemPatron.browseMenu;

  final Map<TabItemPatron, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItemPatron.browseMenu: GlobalKey<NavigatorState>(),
    TabItemPatron.myOrders: GlobalKey<NavigatorState>(),
    TabItemPatron.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItemPatron, WidgetBuilder> get widgetBuilders {
    return {
      TabItemPatron.browseMenu: (_) => Placeholder(),
      TabItemPatron.myOrders: (_) => Placeholder(),
      TabItemPatron.userAccount: (_) => AccountPage()
    };
  }

  void _select(TabItemPatron tabItem) {
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
      child: CupertinoHomeScaffoldPatron(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
