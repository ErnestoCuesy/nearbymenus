import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/section.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuSectionDetailsModel with MenuSectionValidators, ChangeNotifier {
  final Database database;
  final Session session;
  String id;
  String menuId;
  String name;
  bool isLoading;
  bool submitted;

  MenuSectionDetailsModel(
      {@required this.database,
        this.session,
        this.id,
        this.menuId,
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
      await database.setSection(
        Section(
          id: id,
          menuId: menuId,
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

  bool get canSave => menuSectionNameValidator.isValid(name);

  String get menuSectionNameErrorText {
    bool showErrorText = !menuSectionNameValidator.isValid(name);
    return showErrorText ? invalidMenuSectionNameText : null;
  }

  void updateMenuSectionName(String name) => updateWith(name: name);

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
