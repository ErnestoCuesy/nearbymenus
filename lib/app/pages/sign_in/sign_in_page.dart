import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/utilities/logo_image_asset.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_page.dart';
import 'sign_in_button.dart';

class SignInPage extends StatelessWidget {
  final bool allowAnonymousSignIn;
  final bool convertAnonymous;

  const SignInPage({Key key, this.allowAnonymousSignIn, this.convertAnonymous}) : super(key: key);

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign In failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: true);
    try {
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(convertAnonymous: convertAnonymous,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageAsset = Provider.of<LogoImageAsset>(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: screenWidth / 4,
              height: screenHeight / 4,
              child: imageAsset.image,
            ),
          ),
          SizedBox(height: 24.0),
          SizedBox(height: 50.0, child: _buildHeader(context)),
          SizedBox(height: 36.0),
          // EMAIL
          SignInButton(
            text: 'Sign in',
            textColor: FlavourConfig.isManager()
                ? Colors.white
                : Theme.of(context).buttonTheme.colorScheme.onPrimary,
            color: FlavourConfig.isManager()
                ? Colors.black
                : Theme.of(context).colorScheme.primary,
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 24.0),
          // ANON
          if (allowAnonymousSignIn)
          FlatButton(
            child: Text(
                'I\'ll sign-in later',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: () => _signInAnonymously(context),
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
      style: Theme.of(context).primaryTextTheme.headline4,
    );
  }

}
