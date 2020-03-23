import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session.dart';
import 'package:provider/provider.dart';
import 'cupertino_home_scaffold_admin.dart';

class HomePageAdmin extends StatefulWidget {
  final String role;

  const HomePageAdmin({Key key, this.role}) : super(key: key);

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {

  AuthBase auth;
  Session session;
  Database database;

  String get role => widget.role;
  TabItem _currentTab = TabItem.maintainRestaurants;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.maintainRestaurants: GlobalKey<NavigatorState>(),
    TabItem.maintainMenu: GlobalKey<NavigatorState>(),
    TabItem.manageOrders: GlobalKey<NavigatorState>(),
    TabItem.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.maintainRestaurants: (_) => Placeholder(),
      TabItem.maintainMenu: (_) => Placeholder(),
      TabItem.manageOrders: (_) => Placeholder(),
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
    database = Provider.of<Database>(context);
    return WillPopScope(
      onWillPop: () async =>  !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffoldAdmin(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
        roleTabItems: RoleEnumBase.getRoleTabItems(role),
      ),
    );
  }
}
