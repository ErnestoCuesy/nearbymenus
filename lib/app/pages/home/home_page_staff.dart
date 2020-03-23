import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/cupertino_home_scaffold_staff.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session.dart';
import 'package:provider/provider.dart';

class HomePageStaff extends StatefulWidget {
  final String role;

  const HomePageStaff({Key key, this.role}) : super(key: key);

  @override
  _HomePageStaffState createState() => _HomePageStaffState();
}

class _HomePageStaffState extends State<HomePageStaff> {

  AuthBase auth;
  Session session;
  Database database;

  String get role => widget.role;
  TabItem _currentTab = TabItem.manageOrders;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.manageOrders: GlobalKey<NavigatorState>(),
    TabItem.userAccount: GlobalKey<NavigatorState>()
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
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
      child: CupertinoHomeScaffoldStaff(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
        roleTabItems: RoleEnumBase.getRoleTabItems(role),
      ),
    );
  }
}
