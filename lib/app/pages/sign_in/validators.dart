abstract class StringValidator {
  bool isValid(String value);
}

abstract class NumberValidator {
  bool isValid(int value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    if (value == null || value.isEmpty) return false;
    print('String is valid $value');
    return true;
  }
}

class NumericFieldValidator implements NumberValidator{
  @override
  bool isValid(int value) {
    if (value == null || value.isNaN) return false;
    print('Number is valid $value');
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
  final String invalidAddressErrorText = 'Address can\'t be empty';
  final String invalidLocationErrorText = 'Location can\'t be empty';
}

class RestaurantDetailsValidators {
  final StringValidator restaurantNameValidator = NonEmptyStringValidator();
  final StringValidator restaurantLocationValidator = NonEmptyStringValidator();
  final StringValidator typeOfFoodValidator = NonEmptyStringValidator();
  final NumberValidator deliveryRadiusValidator = NumericFieldValidator();
  final String invalidRestaurantNameErrorText = 'Restaurant name can\'t be empty';
  final String invalidRestaurantLocationErrorText = 'Restaurant location can\'t be empty';
  final String invalidTypeOfFoodErrorText = 'Type of food can\'t be empty';
  final String invalidDeliveryRadiusErrorText = 'Delivery radius can\'t be empty';
}

class JobNameAndRatePerHourValidators {
  final StringValidator jobNameValidator = NonEmptyStringValidator();
  final NumberValidator ratePerHourValidator = NumericFieldValidator();
  final String invalidJobNameText = 'Job name can\'t be empty';
  final String invalidRatePerHourText = 'Rate per hour must be a number';
}

// TODO use geo stuff to get user location i.e. estate/complex name