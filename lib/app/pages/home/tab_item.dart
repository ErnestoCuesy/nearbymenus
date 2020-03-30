import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';

enum TabItem {
  restaurantDetails,
  foodMenu,
  drinksMenu,
  manageOrders,
  myOrders,
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
      case ROLE_DEV: {
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
    TabItem.foodMenu,
    TabItem.drinksMenu,
    TabItem.myOrders,
    TabItem.userAccount
  ];
}

class ManagerRoleEnum extends RoleEnumBase {
  final List<TabItem> roleEnumList = const [
    TabItem.restaurantDetails,
    TabItem.foodMenu,
    TabItem.drinksMenu,
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
    TabItem.restaurantDetails,
    TabItem.foodMenu,
    TabItem.drinksMenu,
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
    TabItem.restaurantDetails:
    TabItemData(title: 'Restaurant', icon: Icons.home),
    TabItem.foodMenu:
    TabItemData(title: 'Food Menu', icon: Icons.fastfood),
    TabItem.drinksMenu:
    TabItemData(title: 'Drinks Menu', icon: Icons.local_bar),
    TabItem.manageOrders:
    TabItemData(title: 'Orders', icon: Icons.assignment),
    TabItem.myOrders:
    TabItemData(title: 'My Orders', icon: Icons.shopping_cart),
    TabItem.userAccount:
    TabItemData(title: 'My Account', icon: Icons.person),
  };
}
