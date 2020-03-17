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

enum TabItemDev {
  maintainRestaurants,
  maintainMenu,
  manageOrders,
  browseMenu,
  myOrders,
  userAccount,
}

enum TabItemAdmin {
  maintainRestaurants,
  maintainMenu,
  manageOrders,
  userAccount,
}

enum TabItemPatron {
  browseMenu,
  myOrders,
  userAccount,
}

enum TabItemStaff {
  manageOrders,
  userAccount,
}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItemAdmin, TabItemData> allTabsAdmin = {
    TabItemAdmin.maintainRestaurants:
        TabItemData(title: 'Restaurant', icon: Icons.home),
    TabItemAdmin.maintainMenu:
        TabItemData(title: 'Menu', icon: Icons.import_contacts),
    TabItemAdmin.manageOrders:
        TabItemData(title: 'Orders', icon: Icons.assignment),
    TabItemAdmin.userAccount:
        TabItemData(title: 'My Account', icon: Icons.person),
  };

  static const Map<TabItemStaff, TabItemData> allTabsStaff = {
    TabItemStaff.manageOrders:
    TabItemData(title: 'Orders', icon: Icons.assignment),
    TabItemStaff.userAccount:
    TabItemData(title: 'My Account', icon: Icons.person),
  };

  static const Map<TabItemPatron, TabItemData> allTabsPatron = {
    TabItemPatron.browseMenu:
    TabItemData(title: 'Food', icon: Icons.fastfood),
    TabItemPatron.myOrders:
    TabItemData(title: 'My Orders', icon: Icons.shopping_cart),
    TabItemPatron.userAccount:
    TabItemData(title: 'My Account', icon: Icons.person),
  };

  static const Map<TabItemDev, TabItemData> allTabsDev = {
    TabItemDev.maintainRestaurants:
    TabItemData(title: 'Restaurant', icon: Icons.home),
    TabItemDev.maintainMenu:
    TabItemData(title: 'Menu', icon: Icons.import_contacts),
    TabItemDev.manageOrders:
    TabItemData(title: 'Orders', icon: Icons.assignment),
    TabItemDev.browseMenu:
    TabItemData(title: 'Food', icon: Icons.fastfood),
    TabItemDev.myOrders:
    TabItemData(title: 'My Orders', icon: Icons.shopping_cart),
    TabItemDev.userAccount:
    TabItemData(title: 'My Account', icon: Icons.person),
  };

}
