import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';
import 'package:nearbymenus/app/pages/notifications/messages_page.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';
import 'cupertino_home_scaffold_manager.dart';

class HomePageManager extends StatefulWidget {
  final String role;

  const HomePageManager({Key key, this.role}) : super(key: key);

  @override
  _HomePageManagerState createState() => _HomePageManagerState();
}

class _HomePageManagerState extends State<HomePageManager> {

  AuthBase auth;
  Session session;
  Database database;

  String get role => widget.role;
  TabItem _currentTab = TabItem.restaurant;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.restaurant: GlobalKey<NavigatorState>(),
    TabItem.manageOrders: GlobalKey<NavigatorState>(),
    TabItem.messages: GlobalKey<NavigatorState>(),
    TabItem.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.restaurant: (_) => RestaurantPage(),
      TabItem.manageOrders: (_) => Placeholder(),
      TabItem.messages: (_) => MessagesPage(),
      TabItem.userAccount: (_) => AccountPage(auth: auth, session: session, database: database,)
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
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    return WillPopScope(
      onWillPop: () async =>  !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffoldManager(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
        roleTabItems: RoleEnumBase.getRoleTabItems(role),
      ),
    );
  }
}
