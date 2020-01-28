import 'package:apple_sign_in/apple_sign_in.dart';

class AppleSignInAvailable {
  final bool isAvailable;

  AppleSignInAvailable(this.isAvailable);

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }

}
