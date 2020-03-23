import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {
  maintainRestaurants,
  maintainMenu,
  manageOrders,
  browseMenu,
  myOrders,
  userAccount,
}

abstract class RoleEnumBase {
  List<TabItem> roleEnumList;
  
  static RoleEnumBase getRoleTabItems(String role) {
    RoleEnumBase items;
    switch (role) {
      case 'patron': {
        items = PatronRoleEnum();
      }
      break;
      case 'admin': {
        items = AdminRoleEnum();
      }
      break;
      case 'staff': {
        items = StaffRoleEnum();
      }
      break;
      case 'dev': {
        items = DevRoleEnum();
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
    TabItem.browseMenu,
    TabItem.myOrders,
    TabItem.userAccount
  ];
}

class AdminRoleEnum extends RoleEnumBase {
  final List<TabItem> roleEnumList = const [
    TabItem.maintainRestaurants,
    TabItem.maintainMenu,
    TabItem.manageOrders,
    TabItem.userAccount
  ];
}

class StaffRoleEnum extends RoleEnumBase {
  List<TabItem> roleEnumList = const [
    TabItem.manageOrders,
    TabItem.userAccount
  ];
}

class DevRoleEnum extends RoleEnumBase {
  final List<TabItem> roleEnumList = const [
    TabItem.maintainRestaurants,
    TabItem.maintainMenu,
    TabItem.manageOrders,
    TabItem.myOrders,
    TabItem.userAccount
  ];
}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.maintainRestaurants:
    TabItemData(title: 'Restaurant', icon: Icons.home),
    TabItem.maintainMenu:
    TabItemData(title: 'Menu', icon: Icons.import_contacts),
    TabItem.manageOrders:
    TabItemData(title: 'Orders', icon: Icons.assignment),
    TabItem.browseMenu:
    TabItemData(title: 'Food', icon: Icons.fastfood),
    TabItem.myOrders:
    TabItemData(title: 'My Orders', icon: Icons.shopping_cart),
    TabItem.userAccount:
    TabItemData(title: 'My Account', icon: Icons.person),
  };
}
