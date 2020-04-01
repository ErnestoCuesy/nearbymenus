import 'package:flutter/material.dart';
import 'email_sign_in_page.dart';
import 'sign_in_button.dart';

class SignInPage extends StatelessWidget {

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'images/LauncherIcon.png',
            ),
          ),
          SizedBox(height: 24.0),
          SizedBox(height: 50.0, child: _buildHeader(context)),
          SizedBox(height: 36.0),
          // EMAIL
          SignInButton(
            text: 'Sign in',
            textColor: Theme.of(context).accentColor,
            color: Theme.of(context).buttonColor,
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 36.0),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Welcome',
      textAlign: TextAlign.center,
      style: Theme.of(context).primaryTextTheme.display1,
    );
  }

}
