import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/menu_item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/menu_item_observable_stream.dart';
import 'package:provider/provider.dart';

import 'menu_item_details_model.dart';

class MenuItemDetailsForm extends StatefulWidget {
  final MenuItemDetailsModel model;
  final Map<dynamic, dynamic> optionsMap;

  const MenuItemDetailsForm({Key key, this.model, this.optionsMap}) : super(key: key);

  static Widget create({
    BuildContext context,
    Restaurant restaurant,
    Menu menu,
    MenuItem item,
    MenuItemObservableStream menuItemStream,
  }) {
    final database = Provider.of<Database>(context);
    final session = Provider.of<Session>(context);
    final optionsMap = restaurant.restaurantOptions;
    return ChangeNotifierProvider<MenuItemDetailsModel>(
      create: (context) => MenuItemDetailsModel(
        database: database,
        session: session,
        menu: menu,
        menuItemStream: menuItemStream,
        id: item.id ?? '',
        name: item.name ?? '',
        description: item.description ?? '',
        sequence: item.sequence ?? 0,
        hidden: item.hidden ?? false,
        price: item.price ?? 0.0,
        optionIdList: item.options ?? [],
      ),
      child: Consumer<MenuItemDetailsModel>(
        builder: (context, model, _) => MenuItemDetailsForm(
          model: model,
          optionsMap: optionsMap,
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
  final TextEditingController _sequenceController = TextEditingController();
  final TextEditingController _menuItemPriceController =
      TextEditingController();
  final FocusNode _menuItemNameFocusNode = FocusNode();
  final FocusNode _menuItemDescriptionFocusNode = FocusNode();
  final FocusNode _sequenceFocusNode = FocusNode();
  final FocusNode _menuItemPriceFocusNode = FocusNode();

  MenuItemDetailsModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    if (model != null) {
      _menuItemNameController.text = model.name ?? null;
      _menuItemDescriptionController.text = model.description ?? null;
      _menuItemPriceController.text = model.price.toString() ?? null;
      _sequenceController.text = model.sequence.toString() ?? null;
    }
  }

  @override
  void dispose() {
    _menuItemNameController.dispose();
    _menuItemDescriptionController.dispose();
    _sequenceController.dispose();
    _menuItemPriceController.dispose();
    _menuItemNameFocusNode.dispose();
    _menuItemDescriptionFocusNode.dispose();
    _menuItemPriceFocusNode.dispose();
    _sequenceFocusNode.dispose();
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
        ? _sequenceFocusNode
        : _menuItemPriceFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _sequenceEditingComplete() {
    final newFocus = _sequenceFocusNode;
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
      _sequenceTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildHiddenCheckBox(),
      SizedBox(
        height: 16.0,
      ),
      if (widget.optionsMap.isNotEmpty)
      Center(
        child: Text(
          'Tick all the options that apply',
          style: Theme.of(context).accentTextTheme.subtitle1,
        ),
      ),
      SizedBox(
        height: 8.0,
      ),
      Column(
        children: _buildOptions(),
      ),
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

  List<Widget> _buildOptions() {
    List<Widget> optionList = List<Widget>();
    widget.optionsMap.forEach((key, value) {
      optionList.add(CheckboxListTile(
        title: Text('${value['name']}'),
        value: model.optionCheck(key),
        onChanged: (value) {
          model.updateOptionIdList(key, value);
        },
      ));
    });
    return optionList;
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
        labelText: 'Description (optional)',
        hintText: 'i.e.: Creamy chicken sauteed with baby marrows',
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

  TextField _sequenceTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _sequenceController,
      focusNode: _sequenceFocusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Sequence of appearance',
        hintText: 'i.e.: 0, 10, 20, 30, 40',
        errorText: model.sequenceErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) => model.updateSequence(int.tryParse(value)),
      onEditingComplete: () => _sequenceEditingComplete(),
    );
  }

  Widget _buildHiddenCheckBox() {
    return CheckboxListTile(
      title: const Text('Hide this menu item'),
      value: model.hidden,
      onChanged: model.updateHidden,
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
