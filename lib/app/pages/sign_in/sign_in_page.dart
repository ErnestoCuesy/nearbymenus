import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/pages/sign_in/sign_in_manager.dart';
import 'package:nearbymenus/app/pages/sign_in/social_sign_in_button.dart';
import 'package:nearbymenus/app/services/apple_sign_in_available.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_page.dart';
import 'sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading, this.supportsAppleSignIn})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;
  final bool supportsAppleSignIn;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          builder: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
              supportsAppleSignIn: appleSignInAvailable.isAvailable?? false,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign In failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      await manager.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

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
//      appBar: AppBar(
//        title: Text(
//          'Nearby Menus',
//          style: TextStyle(color: Theme.of(context).accentColor),
//        ),
//        elevation: 2.0,
//      ),
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
          SizedBox(
            height: 200.0,
            child: Image.asset(
              'images/logo.jfif',
            ),
          ),
          SizedBox(height: 24.0),
          SizedBox(height: 50.0, child: _buildHeader(context)),
          SizedBox(height: 24.0),
          // GOOGLE
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          // FACEBOOK
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          // APPLE
          if (supportsAppleSignIn)
            AppleSignInButton(
              style: ButtonStyle.white,
              type: ButtonType.defaultButton,
              onPressed: isLoading ? null : () => _signInWithApple(context),
            ),
          if (supportsAppleSignIn)
            SizedBox(height: 8.0),
          // EMAIL
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.purple[200],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          // ANON
          SignInButton(
            text: 'Sign in anonymously',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
          color: Colors.pink[100]),
    );
  }
}
