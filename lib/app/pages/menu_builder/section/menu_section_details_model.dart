import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/section.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuSectionDetailsModel with MenuSectionValidators, ChangeNotifier {
  final Database database;
  final Session session;
  final Menu menu;
  Restaurant restaurant;
  String id;
  String name;
  String notes;
  bool isLoading;
  bool submitted;

  MenuSectionDetailsModel(
      {@required this.database,
       @required this.session,
       @required this.menu,
       @required this.restaurant,
        this.id,
        this.name,
        this.notes,
        this.isLoading = false,
        this.submitted = false,
      });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    if (id == null || id == '') {
      id = documentIdFromCurrentDate();
    }
    final section = Section(
      id: id,
      menuId: menu.id,
      name: name,
      notes: notes,
    );
    try {
      await database.setSection(section);
      final Map<dynamic, dynamic> sections = restaurant.restaurantMenus[menu.id];
      if (sections.containsKey(id)) {
        restaurant.restaurantMenus[menu.id].update(id, (_) => section.toMap());
      } else {
        restaurant.restaurantMenus[menu.id].putIfAbsent(id, () => section.toMap());
      }
      await Restaurant.setRestaurant(database, restaurant);
    } catch (e) {
      print(e);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText => 'Save';

  bool get canSave => menuSectionNameValidator.isValid(name);

  String get menuSectionNameErrorText {
    bool showErrorText = !menuSectionNameValidator.isValid(name);
    return showErrorText ? invalidMenuSectionNameText : null;
  }

  void updateMenuSectionName(String name) => updateWith(name: name);

  void updateMenuSectionNotes(String notes) => updateWith(notes: notes);

  void updateWith({
    String name,
    String notes,
    bool isLoading,
    bool submitted,
  }) {
    this.name = name ?? this.name;
    this.notes = notes ?? this.notes;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
