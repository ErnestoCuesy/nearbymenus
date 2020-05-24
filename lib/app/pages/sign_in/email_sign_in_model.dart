import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:flutter/foundation.dart';

enum EmailSignInFormType { signIn, register, resetPassword }

class EmailSignInModel with UserCredentialsValidators, ChangeNotifier {
  EmailSignInModel({
    @required this.auth,
    @required this.session,
    this.email,
    this.password,
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthBase auth;
  final Session session;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    session.userDetails = UserDetails(email: email);
    try {
      // await Future.delayed(Duration(seconds: 3)); // Simulate slow network
      switch (formType) {
        case EmailSignInFormType.signIn: {
          await auth.signInWithEmailAndPassword(email, password);
        }
        break;
        case EmailSignInFormType.register: {
          await auth.createUserWithEmailAndPassword(email, password);
        }
        break;
        case EmailSignInFormType.resetPassword: {
          await auth.resetPassword(email);
        }
        break;
      }
    } catch (e) {
      if (e.code == 'PASSWORD_RESET' || e.code == 'EMAIL_NOT_VERIFIED') {
        updateWith(formType: EmailSignInFormType.signIn);
      }
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    String buttonText;
    switch (formType) {
      case EmailSignInFormType.signIn: {
        buttonText = 'Sign In';
      }
      break;
      case EmailSignInFormType.register: {
        buttonText = 'Create an account';
      }
      break;
      case EmailSignInFormType.resetPassword: {
        buttonText = 'Reset password';
      }
      break;
    }
    return buttonText;
  }

  String get secondaryButtonText {
    String buttonText = '';
    switch (formType) {
      case EmailSignInFormType.signIn: {
        buttonText = 'Don\'t have an account? Register';
      }
      break;
      case EmailSignInFormType.register: {
        buttonText = 'Have an account? Sign In';
      }
      break;
      case EmailSignInFormType.resetPassword:
        buttonText = 'Sign In';
      break;
    }
    return buttonText;
  }

  String get tertiaryButtonText => 'Forgot your password?';

  bool get canSubmit {
    bool canSubmitFlag = false;
    switch (formType) {
      case EmailSignInFormType.register:
      case EmailSignInFormType.signIn: {
        if (emailValidator.isValid(email) &&
            passwordValidator.isValid(password) &&
            !isLoading) {
          canSubmitFlag = true;
        }
      }
      break;
      case EmailSignInFormType.resetPassword: {
        if (emailValidator.isValid(email) &&
            !isLoading) {
          canSubmitFlag = true;
        }
      }
      break;
    }
    return canSubmitFlag;
  }

  String get passwordErrorText {
    bool showErrorText = !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggleFormType(EmailSignInFormType toggleForm) {
    updateWith(
      email: '',
      password: '',
      formType: toggleForm,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType = formType ?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submitted = this.submitted;
      notifyListeners();
  }
}
