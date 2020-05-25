import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/session.dart';

enum TabItem {
  restaurant,
  menu,
  manageOrders,
  blockedOrders,
  myOrders,
  messages,
  userAccount,
}

abstract class RoleEnumBase {
  List<TabItem> roleEnumList;
  
  static RoleEnumBase getRoleTabItems(String role) {
    RoleEnumBase items;
    switch (role) {
      case ROLE_PATRON: {
        items = PatronRoleEnum();
      }
      break;
      case ROLE_MANAGER: {
        items = ManagerRoleEnum();
      }
      break;
      case ROLE_STAFF: {
        items = StaffRoleEnum();
      }
      break;
    }
    return items;
  }

  static List<BottomNavigationBarItem> itemsForRole(BuildContext context, TabItem currentTab, RoleEnumBase roleTabItems) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
    roleTabItems.roleEnumList.forEach((roleItem) {
      items.add(_buildItem(context, roleItem, currentTab));
    });
    return items;
  }

  static BottomNavigationBarItem _buildItem(BuildContext context, TabItem tabItem, TabItem currentTab) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem
        ? Theme.of(context).tabBarTheme.labelColor
        : Theme.of(context).tabBarTheme.unselectedLabelColor;
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon),
      title: Text(
        itemData.title,
        style: TextStyle(color: color),
      ),
    );
  }

}

class PatronRoleEnum extends RoleEnumBase {
  List<TabItem> roleEnumList = const [
    TabItem.menu,
    TabItem.messages,
    TabItem.userAccount,
  ];
}

class ManagerRoleEnum extends RoleEnumBase {
  final List<TabItem> roleEnumList = const [
    TabItem.restaurant,
    TabItem.manageOrders,
    TabItem.blockedOrders,
    TabItem.messages,
    TabItem.userAccount,
  ];
}

class StaffRoleEnum extends RoleEnumBase {
  List<TabItem> roleEnumList = const [
    TabItem.restaurant,
    TabItem.messages,
    TabItem.userAccount,
  ];
}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.restaurant:
    TabItemData(title: 'Restaurants', icon: Icons.home),
    TabItem.menu:
    TabItemData(title: 'Menu', icon: Icons.fastfood),
    TabItem.manageOrders:
    TabItemData(title: 'Orders', icon: Icons.assignment),
    TabItem.blockedOrders:
    TabItemData(title: 'Locked Orders', icon: Icons.lock),
    TabItem.myOrders:
    TabItemData(title: 'Orders History', icon: Icons.update),
    TabItem.messages:
    TabItemData(title: 'Messages', icon: Icons.message),
    TabItem.userAccount:
    TabItemData(title: 'Profile', icon: Icons.account_circle),
  };

}
