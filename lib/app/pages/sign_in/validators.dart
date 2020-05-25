abstract class StringValidator {
  bool isValid(String value);
}

abstract class NumberValidator {
  bool isValid(int value);
}

abstract class DoubleNumberValidator {
  bool isValid(double value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    if (value == null || value.isEmpty) return false;
    return true;
  }
}

class NumericFieldValidator implements NumberValidator{
  @override
  bool isValid(int value) {
    if (value == null || value.isNaN) return false;
    return true;
  }
}

class DoubleNumericFieldValidator implements DoubleNumberValidator{
  @override
  bool isValid(double value) {
    if (value == null || value.isNaN) return false;
    return true;
  }
}

class UserCredentialsValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}

class UserDetailsValidators {
  final StringValidator userNameValidator = NonEmptyStringValidator();
  final StringValidator userAddressValidator = NonEmptyStringValidator();
  final StringValidator userLocationValidator = NonEmptyStringValidator();
  final String invalidUsernameErrorText = 'Name can\'t be empty';
  final String invalidAddressErrorText = 'Can\'t be empty';
  final String invalidLocationErrorText = 'Location can\'t be empty';
}

class RestaurantDetailsValidators {
  final StringValidator restaurantNameValidator = NonEmptyStringValidator();
  final StringValidator restaurantAddress1Validator = NonEmptyStringValidator();
  final StringValidator typeOfFoodValidator = NonEmptyStringValidator();
  final NumberValidator deliveryRadiusValidator = NumericFieldValidator();
  final StringValidator telephoneNumberValidator = NonEmptyStringValidator();
  final String invalidRestaurantNameErrorText = 'Restaurant name can\'t be empty';
  final String invalidRestaurantAddress1ErrorText = 'Restaurant address can\'t be empty';
  final String invalidTypeOfFoodErrorText = 'Type of food can\'t be empty';
  final String invalidDeliveryRadiusErrorText = 'Delivery radius can\'t be empty';
  final String invalidTelephoneNumberErrorText = 'Telephone number can\'t be empty';
}

class RestaurantMenuValidators {
  final StringValidator menuNameValidator = NonEmptyStringValidator();
  final String invalidMenuNameText = 'Menu name can\'t be empty';
  final NumberValidator sequenceValidator = NumericFieldValidator();
  final String invalidSequenceText = 'Sequence can\'t be empty and must be greater than zero';
}

class MenuItemValidators {
  final StringValidator menuItemNameValidator = NonEmptyStringValidator();
  final StringValidator menuItemDescriptionValidator = NonEmptyStringValidator();
  final DoubleNumberValidator menuItemPriceValidator = DoubleNumericFieldValidator();
  final NumberValidator sequenceValidator = NumericFieldValidator();
  final String invalidMenuItemNameText = 'Menu item name can\'t be empty';
  final String invalidMenuItemDescriptionText = 'Description can\'t be empty';
  final String invalidMenuItemPriceText = 'Price must be a number';
  final String invalidSequenceText = 'Sequence can\'t be empty and must be greater than zero';
}

class OptionItemValidators {
  final StringValidator optionItemNameValidator = NonEmptyStringValidator();
  final String invalidOptionItemNameText = 'Option item name can\'t be empty';
}

class RestaurantOptionValidators {
  final StringValidator optionNameValidator = NonEmptyStringValidator();
  final String invalidOptionNameText = 'Option name can\'t be empty';
  final NumberValidator numberAllowedValidator = NumericFieldValidator();
  final String invalidNumberAllowedText = 'Must be greater than zero and less or equal to number of options.';
}
