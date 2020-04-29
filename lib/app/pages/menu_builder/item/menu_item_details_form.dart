import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/section.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

import 'menu_item_details_model.dart';

class MenuItemDetailsForm extends StatefulWidget {
  final MenuItemDetailsModel model;

  const MenuItemDetailsForm({Key key, this.model}) : super(key: key);

  static Widget create({
    BuildContext context,
    Session session,
    Database database,
    Restaurant restaurant,
    Menu menu,
    Section section,
    Item item,
  }) {
    return ChangeNotifierProvider<MenuItemDetailsModel>(
      create: (context) => MenuItemDetailsModel(
        database: database,
        session: session,
        restaurant: restaurant,
        menu: menu,
        section: section,
        id: item.id ?? '',
        name: item.name ?? '',
        description: item.description ?? '',
        price: item.price ?? 0.0,
        isExtra: item.isExtra ?? false,
      ),
      child: Consumer<MenuItemDetailsModel>(
        builder: (context, model, _) => MenuItemDetailsForm(
          model: model,
        ),
      ),
    );
  }

  @override
  _MenuItemDetailsFormState createState() => _MenuItemDetailsFormState();
}

class _MenuItemDetailsFormState extends State<MenuItemDetailsForm> {
  final TextEditingController _menuItemNameController = TextEditingController();
  final TextEditingController _menuItemDescriptionController =
      TextEditingController();
  final TextEditingController _menuItemPriceController =
      TextEditingController();
  final FocusNode _menuItemNameFocusNode = FocusNode();
  final FocusNode _menuItemDescriptionFocusNode = FocusNode();
  final FocusNode _menuItemPriceFocusNode = FocusNode();

  MenuItemDetailsModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    if (model != null) {
      _menuItemNameController.text = model.name ?? null;
      _menuItemDescriptionController.text = model.description ?? null;
      _menuItemPriceController.text = model.price.toString() ?? null;
    }
  }

  @override
  void dispose() {
    _menuItemNameController.dispose();
    _menuItemDescriptionController.dispose();
    _menuItemPriceController.dispose();
    _menuItemNameFocusNode.dispose();
    _menuItemDescriptionFocusNode.dispose();
    _menuItemPriceFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await model.save();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Item Section',
        exception: e,
      ).show(context);
    }
  }

  void _menuItemNameEditingComplete() {
    final newFocus = model.menuItemNameValidator.isValid(model.name)
        ? _menuItemNameFocusNode
        : _menuItemNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _menuItemDescriptionEditingComplete() {
    final newFocus =
        model.menuItemDescriptionValidator.isValid(model.description)
            ? _menuItemDescriptionFocusNode
            : _menuItemNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _menuItemPriceEditingComplete() {
    final newFocus = model.menuItemPriceValidator.isValid(model.price)
        ? _menuItemPriceFocusNode
        : _menuItemPriceFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildMenuItemNameTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildMenuItemDescriptionTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildMenuItemPriceTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildMenuItemIsExtraTextField(),
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

  TextField _buildMenuItemNameTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _menuItemNameController,
      focusNode: _menuItemNameFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Menu item name',
        hintText: 'i.e.: Spaghetti Bolognaise or Chicken Burger',
        errorText: model.menuItemNameErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: model.updateMenuItemName,
      onEditingComplete: () => _menuItemNameEditingComplete(),
    );
  }

  TextField _buildMenuItemDescriptionTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _menuItemDescriptionController,
      focusNode: _menuItemDescriptionFocusNode,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'i.e.: Creamy chicken sauteed with baby marrows',
        errorText: model.menuItemDescriptionErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: model.updateMenuItemDescription,
      onEditingComplete: () => _menuItemDescriptionEditingComplete(),
    );
  }

  TextField _buildMenuItemPriceTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _menuItemPriceController,
      focusNode: _menuItemPriceFocusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Price',
        hintText: 'i.e.: 10.99',
        errorText: model.menuItemPriceErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      onChanged: (value) => model.updateMenuItemPrice(value),
      onEditingComplete: () => _menuItemPriceEditingComplete(),
    );
  }

  Widget _buildMenuItemIsExtraTextField() {
    return CheckboxListTile(
      title: const Text('Is extra or side dish'),
      value: model.isExtra,
      onChanged: model.updateMenuItemIsExtra,
      secondary: const Icon(Icons.note_add),
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
