import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {
  restaurant,
  menu,
  messages,
  userAccount,
}

abstract class RoleEnumBase {
  List<TabItem> roleEnumList;
  
  static RoleEnumBase getRoleTabItems() {
    return RoleEnum();
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

class RoleEnum extends RoleEnumBase {
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
    TabItem.messages:
    TabItemData(title: 'Messages', icon: Icons.message),
    TabItem.userAccount:
    TabItemData(title: 'Profile', icon: Icons.account_circle),
  };

}
