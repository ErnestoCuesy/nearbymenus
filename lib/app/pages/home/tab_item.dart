import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { roles, restaurants, account}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.roles: TabItemData(title: 'My Roles', icon: Icons.group),
    TabItem.restaurants: TabItemData(title: 'Restaurants', icon: Icons.local_dining),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}