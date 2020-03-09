import 'package:nearbymenus/app/pages/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register, forgotPassword }

class EmailSignInModel with UserCredentialsValidators {
  EmailSignInModel({
    this.email,
    this.password,
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
  }

  bool get canSubmit {
      return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EmailSignInModel &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              password == other.password &&
              formType == other.formType &&
              isLoading == other.isLoading &&
              submitted == other.submitted;

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      formType.hashCode ^
      isLoading.hashCode ^
      submitted.hashCode;

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }

}
