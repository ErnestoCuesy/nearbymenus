import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/pages/session/user_details_model.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class UserDetailsForm extends StatefulWidget {

  final UserDetailsModel model;

  const UserDetailsForm({Key key, this.model}) : super(key: key);

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return ChangeNotifierProvider<UserDetailsModel>(
      create: (context) => UserDetailsModel(database: database),
      child: Consumer<UserDetailsModel>(
        builder: (context, model, _) => UserDetailsForm(model: model,),
      ),
    );
  }

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();

}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _userLocationController = TextEditingController();
  final TextEditingController _userNearestRestaurantController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _userAddressFocusNode = FocusNode();

  UserDetailsModel get model => widget.model;

  @override
  void dispose() {
    _userNameController.dispose();
    _userAddressController.dispose();
    _userLocationController.dispose();
    _userNearestRestaurantController.dispose();
    _userNameFocusNode.dispose();
    _userAddressFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final deviceInfo = Provider.of<DeviceInfo>(context);
    model.deviceName = deviceInfo.deviceName;
    try {
      // await Future.delayed(Duration(seconds: 3)); // Simulate slow network
      await model.save();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Save User Details',
        exception: e,
      ).show(context);
    }
  }

  void _userNameEditingComplete() {
    final newFocus = model.userNameValidator.isValid(model.userName)
        ? _userAddressFocusNode
        : _userNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _userAddressEditingComplete() {
    final newFocus = model.userAddressValidator.isValid(model.userAddress)
        ? _save()
        : _userAddressFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildUserNameTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildUserAddressTextField(),
      SizedBox(
        height: 16.0,
      ),
      _buildUserLocationTextField(),
      SizedBox(
        height: 16.0,
      ),
      _buildNearestRestaurantTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        context: context,
        text: model.primaryButtonText,
        color: model.canSave ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
        onPressed: model.canSave ? _save : null,
      ),
      SizedBox(
        height: 8.0,
      ),
    ];
  }

  TextField _buildUserNameTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _userNameController,
      focusNode: _userNameFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Your name',
        errorText: model.userNameErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: model.updateUserName,
      onEditingComplete: () => _userNameEditingComplete(),
    );
  }

  TextField _buildUserAddressTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _userAddressController,
      focusNode: _userAddressFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Address',
        hintText: 'Unit, flat or house number',
        errorText: model.userAddressErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: model.updateUserAddress,
      onEditingComplete: () => _userAddressEditingComplete(),
    );
  }

  TextField _buildUserLocationTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _userLocationController,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Complex or Estate Name',
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      // onChanged: model.updateUserLocation,
    );
  }

  TextField _buildNearestRestaurantTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _userNearestRestaurantController,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Nearest Restaurant',
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      //onChanged: model.updateUserNearestRestaurant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    // _userNameController.text = session.userDetails.name;
    // _userAddressController.text = session.userDetails.address;
    _userNearestRestaurantController.text = session.nearestRestaurant.name;
    _userLocationController.text = session.nearestRestaurant.complexName;
    // model.userName = session.userDetails.name;
    // model.userAddress = session.userDetails.address;
    model.userNearestRestaurant = session.nearestRestaurant.name;
    model.userLocation = session.nearestRestaurant.complexName;
    model.userRole = session.userDetails.role;
    return Container(
      color: Theme
          .of(context)
          .dialogBackgroundColor,
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
