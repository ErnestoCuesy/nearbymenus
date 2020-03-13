import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/account/account_page.dart';
import 'package:nearbymenus/app/pages/home/tab_item.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:provider/provider.dart';
import 'cupertino_home_scaffold.dart';

class HomePage extends StatefulWidget {
  final UserDetails userDetails;

  const HomePage({Key key, this.userDetails}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  UserDetails get userDetails => widget.userDetails;
  TabItem _currentTab = TabItem.orders;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.orders: GlobalKey<NavigatorState>(),
    TabItem.restaurants: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>()
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.orders: (_) => Placeholder(),
      TabItem.restaurants: (_) => Placeholder(),
      TabItem.account: (_) => AccountPage(userDetails: widget.userDetails)
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
    final deviceInfo = Provider.of<DeviceInfo>(context);
    final database = Provider.of<Database>(context);
    database.setUserDetails(UserDetails(
        userName: userDetails.userName,
        userAddress: userDetails.userAddress,
        userLocation: userDetails.userLocation,
        userRole: userDetails.userRole,
        userDeviceName: deviceInfo.deviceName
    ));
    return WillPopScope(
      onWillPop: () async =>  !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
