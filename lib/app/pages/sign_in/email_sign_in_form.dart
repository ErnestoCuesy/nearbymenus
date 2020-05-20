import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/sign_in/email_sign_in_model.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class EmailSignInForm extends StatefulWidget {

  EmailSignInForm({@required this.model});

  final EmailSignInModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final session = Provider.of<Session>(context);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth, session: session),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => EmailSignInForm(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInModel get model => widget.model;

  @override
  void dispose() {
    print('dispose called');
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      // await Future.delayed(Duration(seconds: 3)); // Simulate slow network
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _passwordEditingComplete() {
    if (model.passwordValidator.isValid(model.password)) {
      _submit();
    } else {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    }
  }

  void _toggleFormType(EmailSignInFormType toggleForm) {
    model.toggleFormType(toggleForm);
    // _emailController.clear();
    // _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      if (model.formType == EmailSignInFormType.register ||
          model.formType == EmailSignInFormType.signIn)
      _buildEmailPasswordField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        context: context,
        text: model.primaryButtonText,
        color: model.canSubmit ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: () {
          if (!model.isLoading) {
            if (model.formType == EmailSignInFormType.signIn) {
              _toggleFormType(EmailSignInFormType.register);
            } else {
              _toggleFormType(EmailSignInFormType.signIn);
            }
          }
        },
      ),
      if (model.formType == EmailSignInFormType.signIn)
        FlatButton(
          child: Text(model.tertiaryButtonText),
          onPressed: () {
            if (!model.isLoading) {
              _toggleFormType(EmailSignInFormType.resetPassword);
            }
          },
        ),
    ];
  }

  TextField _buildEmailPasswordField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: () => _passwordEditingComplete(),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      controller: _emailController,
      focusNode: _emailFocusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'i.e.: test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
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
