import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/date_time_picker.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_details_model.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class RestaurantDetailsForm extends StatefulWidget {
  final RestaurantDetailsModel model;

  const RestaurantDetailsForm({Key key, this.model}) : super(key: key);

  static Widget create(BuildContext context, Session session, Database database, Restaurant restaurant) {
    return ChangeNotifierProvider<RestaurantDetailsModel>(
      create: (context) => RestaurantDetailsModel(
        database: database,
        session: session,
        id: restaurant.id ?? '',
        managerId: restaurant.managerId ?? '',
        name: restaurant.name ?? '',
        restaurantLocation: restaurant.restaurantLocation ?? '',
        typeOfFood: restaurant.typeOfFood ?? '',
        coordinates: restaurant.coordinates ?? session.position,
        deliveryRadius: restaurant.deliveryRadius ?? 0,
        workingHoursFrom: restaurant.workingHoursFrom ?? TimeOfDay.now(),
        workingHoursTo: restaurant.workingHoursTo ?? TimeOfDay.now(),
        notes: restaurant.notes ?? '',
        active: restaurant.active ?? false,
        open: restaurant.open ?? false,
        acceptingStaffRequests: restaurant.acceptingStaffRequests ?? false
      ),
      child: Consumer<RestaurantDetailsModel>(
        builder: (context, model, _) => RestaurantDetailsForm(
          model: model,
        ),
      ),
    );
  }

  @override
  _RestaurantDetailsFormState createState() => _RestaurantDetailsFormState();
}

class _RestaurantDetailsFormState extends State<RestaurantDetailsForm> {
  final TextEditingController _restaurantNameController =
      TextEditingController();
  final TextEditingController _restaurantLocationController = TextEditingController();
  final TextEditingController _typeOfFoodController = TextEditingController();
  final TextEditingController _deliveryRadiusController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _restaurantNameFocusNode = FocusNode();
  final FocusNode _restaurantLocationFocusNode = FocusNode();
  final FocusNode _typeOfFoodFocusNode = FocusNode();
  final FocusNode _coordinatesFocusNode = FocusNode();
  final FocusNode _deliveryRadiusFocusNode = FocusNode();
  final FocusNode _hoursFromFocusNode = FocusNode();
  final FocusNode _hoursToFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();
  final FocusNode _statusFocusNode = FocusNode();

  TimeOfDay _openFrom = TimeOfDay.now();
  TimeOfDay _openTo = TimeOfDay.now();

  RestaurantDetailsModel get model => widget.model;


  @override
  void initState() {
    super.initState();
    if (model != null) {
      _restaurantNameController.text = model.name ?? null;
      _restaurantLocationController.text = model.restaurantLocation ?? null;
      _typeOfFoodController.text = model.typeOfFood ?? null;
      _deliveryRadiusController.text = model.deliveryRadius.toString() ?? null;
      _notesController.text = model.notes ?? null;
      _openFrom = model.workingHoursFrom ?? null;
      _openTo = model.workingHoursTo ?? null;
    }
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _restaurantLocationController.dispose();
    _typeOfFoodController.dispose();
    _deliveryRadiusController.dispose();
    _notesController.dispose();
    _restaurantNameFocusNode.dispose();
    _restaurantLocationFocusNode.dispose();
    _typeOfFoodFocusNode.dispose();
    _coordinatesFocusNode.dispose();
    _deliveryRadiusFocusNode.dispose();
    _hoursFromFocusNode.dispose();
    _hoursToFocusNode.dispose();
    _notesFocusNode.dispose();
    _statusFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
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

  void _restaurantNameEditingComplete() {
    final newFocus = model.restaurantNameValidator.isValid(model.name)
        ? _typeOfFoodFocusNode
        : _restaurantNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _typeOfFoodEditingComplete() {
    final newFocus = model.typeOfFoodValidator.isValid(model.typeOfFood)
        ? _restaurantLocationFocusNode
        : _typeOfFoodFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _restaurantLocationEditingComplete() {
    final newFocus = model.restaurantLocationValidator.isValid(model.restaurantLocation)
        ? _deliveryRadiusFocusNode
        : _restaurantLocationFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _deliveryRadiusEditingComplete() {
    final newFocus = model.deliveryRadiusValidator.isValid(model.deliveryRadius)
        ? _hoursFromFocusNode
        : _deliveryRadiusFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _hoursFromEditingComplete() {
    final newFocus = _hoursToFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _hoursToEditingComplete() {
    final newFocus = _notesFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  // TODO add a use current location check box and a way to refresh if user moves around

  List<Widget> _buildChildren() {
    return [
      _buildRestaurantNameTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildTypeOfFoodTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildRestaurantLocationTextField(),
      SizedBox(
        height: 16.0,
      ),
      _buildDeliveryRadiusTextField(),
      SizedBox(
        height: 16.0,
      ),
      _buildHoursFromPicker(),
      SizedBox(
        height: 8.0,
      ),
      _buildHoursToTextPicker(),
      SizedBox(
        height: 16.0,
      ),
      _buildNotesTextField(),
      SizedBox(
        height: 16.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Activate restaurant listing',
                style: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildActiveSwitch(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Open restaurant',
                style: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildOpenSwitch(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Allow staff requests to join',
                style: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildAcceptingStaffRequestsSwitch()
            ],
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

  // TODO add payment option checkboxes
  // TODO add use current location checkbox
  // TODO allow recalculation of current location

  Widget _buildActiveSwitch() {
    return CupertinoSwitch(
      value: model.active,
      onChanged: model.updateActive,
    );
  }

  Widget _buildOpenSwitch() {
    return CupertinoSwitch(
      value: model.open,
      onChanged: model.updateOpen,
    );
  }

  Widget _buildAcceptingStaffRequestsSwitch() {
    return CupertinoSwitch(
      value: model.acceptingStaffRequests,
      onChanged: model.updateAcceptingStaffRequests,
    );
  }

  TextField _buildRestaurantNameTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _restaurantNameController,
      focusNode: _restaurantNameFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Restaurant name',
        hintText: 'i.e.: Johnny\'s',
        errorText: model.restaurantNameErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: model.updateRestaurantName,
      onEditingComplete: () => _restaurantNameEditingComplete(),
    );
  }

  TextField _buildRestaurantLocationTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _restaurantLocationController,
      focusNode: _restaurantLocationFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Restaurant\'s location',
        hintText: 'i.e.: Lonehill Village Estate',
        errorText: model.restaurantLocationErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: model.updateRestaurantLocation,
      onEditingComplete: () => _restaurantLocationEditingComplete(),
    );
  }

  TextField _buildTypeOfFoodTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _typeOfFoodController,
      focusNode: _typeOfFoodFocusNode,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Type of food',
        hintText: 'i.e: Mexican',
        errorText: model.typeOfFoodErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: model.updateTypeOfFood,
      onEditingComplete: () => _typeOfFoodEditingComplete(),
    );
  }

  TextField _buildDeliveryRadiusTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _deliveryRadiusController,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Delivery radius (in metres)',
        hintText: 'i.e.: 1000',
        errorText: model.deliveryRadiusErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (value) => model.updateDeliveryRadius(int.tryParse(value)),
      onEditingComplete: () => _deliveryRadiusEditingComplete(),
    );
  }

  Widget _buildHoursFromPicker() {
    return DateTimePicker(
      labelText: 'Open from',
      selectedDate: null,
      // selectedTime: model.workingHoursFrom,
      selectedTime: _openFrom,
      onSelecedtDate: null,
      // onSelectedTime: (value) => model.updateWorkingHoursFrom(value),
      onSelectedTime: (time) {
        print('Hours from: ${time.toString()}');
        model.updateWorkingHoursFrom(time);
        setState(() {
          _openFrom = time;
        });
      },
    );
  }

  Widget _buildHoursToTextPicker() {
    return DateTimePicker(
      labelText: 'Open until',
      selectedDate: null,
      selectedTime: _openTo,
      onSelecedtDate: null,
      onSelectedTime: (time) {
        print('Hours to: ${time.toString()}');
        model.updateWorkingHoursTo(time);
        setState(() {
          _openTo = time;
        });
      },
    );
  }

  TextField _buildNotesTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _notesController,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Special notice to patrons',
        hintText: 'i.e.: Residents only',
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (value) => model.updateNotes(value),
      onEditingComplete: () => _save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
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
