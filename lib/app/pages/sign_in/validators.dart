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

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}

class JobNameAndRatePerHourValidators {
  final StringValidator jobNameValidator = NonEmptyStringValidator();
  final NumberValidator ratePerHourValidator = NumericFieldValidator();
  final String invalidJobNameText = 'Job name can\'t be empty';
  final String invalidRatePerHourText = 'Rate per hour must be a number';
}