import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/item_image.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/images/item_image_details_model.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class ItemImageDetailsForm extends StatefulWidget {
  final ItemImageDetailsModel model;
  final ItemImage itemImage;

  const ItemImageDetailsForm({Key key, this.model, this.itemImage}) : super(key: key);

  static Widget create({
    BuildContext context,
    Restaurant restaurant,
    ItemImage itemImage,
  }) {
    final database = Provider.of<Database>(context);
    final image = itemImage.url != '' ? Image.network(itemImage.url) : null;
    return ChangeNotifierProvider<ItemImageDetailsModel>(
      create: (context) => ItemImageDetailsModel(
        database: database,
        restaurant: restaurant,
        id: itemImage.id ?? '',
        description: itemImage.description ?? '',
        url: itemImage.url ?? '',
        image: image,
      ),
      child: Consumer<ItemImageDetailsModel>(
        builder: (context, model, _) => ItemImageDetailsForm(
          model: model,
          itemImage: itemImage,
        ),
      ),
    );
  }

  @override
  _ItemImageDetailsFormState createState() => _ItemImageDetailsFormState();
}

class _ItemImageDetailsFormState extends State<ItemImageDetailsForm> {
  final TextEditingController _itemImageDescriptionController =
  TextEditingController();
  final FocusNode _itemImageDescriptionFocusNode = FocusNode();
  double buttonSize = 200.0;

  ItemImageDetailsModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    if (model != null) {
      _itemImageDescriptionController.text = model.description ?? null;
    }
  }

  @override
  void dispose() {
    _itemImageDescriptionController.dispose();
    _itemImageDescriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await model.save();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Item Image Section',
        exception: e,
      ).show(context);
    }
  }

  void _itemImageDescriptionEditingComplete() {
    final newFocus =
    model.itemImageDescriptionValidator.isValid(model.description)
        ? _itemImageDescriptionFocusNode
        : _itemImageDescriptionFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      _buildItemImageDescriptionTextField(context),
      SizedBox(
        height: 16.0,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: model.getImage,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tap to change image',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                if (model.imageChanged && model.imageFile != null)
                Expanded(child: Image.file(model.imageFile)),
                if (!model.imageChanged && model.image != null)
                Expanded(child: model.image),
                if (model.image == null && model.imageFile == null)
                Icon(Icons.image,size: 36.0,),
              ],
            ),
          ),
        ],
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

  TextField _buildItemImageDescriptionTextField(BuildContext context) {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _itemImageDescriptionController,
      focusNode: _itemImageDescriptionFocusNode,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'i.e.: Creamy chicken sauteed with baby marrows',
        errorText: model.itemImageDescriptionErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: model.updateItemImageDescription,
      onEditingComplete: () => _itemImageDescriptionEditingComplete(),
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
          children: _buildChildren(context),
        ),
      ),
    );
  }
}
