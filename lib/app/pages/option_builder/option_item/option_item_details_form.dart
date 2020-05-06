import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/option.dart';
import 'package:nearbymenus/app/models/option_item.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

import 'option_item_details_model.dart';

class OptionItemDetailsForm extends StatefulWidget {
  final OptionItemDetailsModel model;

  const OptionItemDetailsForm({Key key, this.model}) : super(key: key);

  static Widget create({
    BuildContext context,
    Session session,
    Database database,
    Restaurant restaurant,
    Option option,
    OptionItem item,
  }) {
    return ChangeNotifierProvider<OptionItemDetailsModel>(
      create: (context) => OptionItemDetailsModel(
        database: database,
        session: session,
        restaurant: restaurant,
        option: option,
        id: item.id ?? '',
        name: item.name ?? '',
      ),
      child: Consumer<OptionItemDetailsModel>(
        builder: (context, model, _) => OptionItemDetailsForm(
          model: model,
        ),
      ),
    );
  }

  @override
  _OptionItemDetailsFormState createState() => _OptionItemDetailsFormState();
}

class _OptionItemDetailsFormState extends State<OptionItemDetailsForm> {
  final TextEditingController _optionItemNameController = TextEditingController();
  final FocusNode _optionItemNameFocusNode = FocusNode();

  OptionItemDetailsModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    if (model != null) {
      _optionItemNameController.text = model.name ?? null;
    }
  }

  @override
  void dispose() {
    _optionItemNameController.dispose();
    _optionItemNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await model.save();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Option Item Section',
        exception: e,
      ).show(context);
    }
  }

  void _optionItemNameEditingComplete() {
    final newFocus = _optionItemNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildOptionItemNameTextField(),
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

  TextField _buildOptionItemNameTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _optionItemNameController,
      focusNode: _optionItemNameFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Option item name',
        hintText: 'i.e.: Pasta, Bread, Eggs',
        errorText: model.optionItemNameErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: model.updateOptionItemName,
      onEditingComplete: () => _optionItemNameEditingComplete(),
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