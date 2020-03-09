import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { restaurants, orders, account}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.restaurants: TabItemData(title: 'Restaurants', icon: Icons.local_dining),
    TabItem.orders: TabItemData(title: 'My Orders', icon: Icons.shopping_cart),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}