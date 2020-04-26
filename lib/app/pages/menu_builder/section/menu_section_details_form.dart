import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/section.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/section/menu_section_details_model.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuSectionDetailsForm extends StatefulWidget {
  final MenuSectionDetailsModel model;

  const MenuSectionDetailsForm({Key key, this.model}) : super(key: key);

  static Widget create({
    BuildContext context,
    Session session,
    Database database,
    Restaurant restaurant,
    Menu menu,
    Section section,
  }) {
    return ChangeNotifierProvider<MenuSectionDetailsModel>(
      create: (context) => MenuSectionDetailsModel(
        database: database,
        session: session,
        restaurant: restaurant,
        menu: menu,
        id: section.id ?? '',
        name: section.name ?? '',
        notes: section.notes ?? '',
      ),
      child: Consumer<MenuSectionDetailsModel>(
        builder: (context, model, _) => MenuSectionDetailsForm(
          model: model,
        ),
      ),
    );
  }

  @override
  _MenuSectionDetailsFormState createState() => _MenuSectionDetailsFormState();
}

class _MenuSectionDetailsFormState extends State<MenuSectionDetailsForm> {
  final TextEditingController _menuSectionNameController =
      TextEditingController();
  final TextEditingController _menuSectionNotesController =
      TextEditingController();
  final FocusNode _menuSectionNameFocusNode = FocusNode();
  final FocusNode _menuSectionNotesFocusNode = FocusNode();

  MenuSectionDetailsModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    if (model != null) {
      _menuSectionNameController.text = model.name ?? null;
      _menuSectionNotesController.text = model.notes ?? null;
    }
  }

  @override
  void dispose() {
    _menuSectionNameController.dispose();
    _menuSectionNotesController.dispose();
    _menuSectionNameFocusNode.dispose();
    _menuSectionNotesFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await model.save();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Menu Section',
        exception: e,
      ).show(context);
    }
  }

  void _menuSectionNameEditingComplete() {
    final newFocus = model.menuSectionNameValidator.isValid(model.name)
        ? _menuSectionNameFocusNode
        : _menuSectionNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _menuSectionNotesEditingComplete() {
    final newFocus = _menuSectionNotesFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildMenuSectionNameTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildMenuSectionNotesTextField(),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        context: context,
        text: model.primaryButtonText,
        color: model.canSave
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor,
        onPressed: model.canSave ? _save : null,
      ),
      SizedBox(
        height: 8.0,
      ),
    ];
  }

  TextField _buildMenuSectionNameTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _menuSectionNameController,
      focusNode: _menuSectionNameFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Menu section name',
        hintText: 'i.e.: Starters or Desserts',
        errorText: model.menuSectionNameErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: model.updateMenuSectionName,
      onEditingComplete: () => _menuSectionNameEditingComplete(),
    );
  }

  TextField _buildMenuSectionNotesTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _menuSectionNotesController,
      focusNode: _menuSectionNotesFocusNode,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Notes (optional)',
        hintText: 'i.e.: All dishes served with salad or chips',
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: model.updateMenuSectionNotes,
      onEditingComplete: () => _menuSectionNotesEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }
}
