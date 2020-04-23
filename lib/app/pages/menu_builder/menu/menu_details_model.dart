import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuDetailsModel with RestaurantMenuValidators, ChangeNotifier {
  final Database database;
  final Session session;
  String id;
  String restaurantId;
  String name;
  bool isLoading;
  bool submitted;

  MenuDetailsModel(
      {@required this.database,
      this.session,
      this.id,
      this.restaurantId,
      this.name,
      this.isLoading = false,
      this.submitted = false,
  });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    if (id == null || id == '') {
      id = documentIdFromCurrentDate();
    }
    try {
      await database.setMenu(
        Menu(
            id: id,
            restaurantId: session.nearestRestaurant.id,
            name: name,
        ),
      );
    } catch (e) {
      print(e);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText => 'Save';

  bool get canSave => menuNameValidator.isValid(name);

  String get menuNameErrorText {
    bool showErrorText = !menuNameValidator.isValid(name);
    return showErrorText ? invalidMenuNameText : null;
  }

  void updateMenuName(String name) => updateWith(name: name);

  void updateWith({
    String name,
    bool isLoading,
    bool submitted,
  }) {
    this.name = name ?? this.name;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
