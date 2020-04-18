import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class UserAuth {
  UserAuth({
    @required this.uid,
    @required this.photoUrl,
    @required this.displayName,
  });
  final String uid;
  final String photoUrl;
  final String displayName;
}

abstract class AuthBase {
  Stream<UserAuth> get onAuthStateChanged;
  Future<UserAuth> currentUser();
  Future<UserAuth> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _fireBaseAuth = FirebaseAuth.instance;

  UserAuth _userFromFirebase(FirebaseUser user) {
    print('FirebaseUser => ${user.displayName}');
    return user == null
        ? null
        : UserAuth(
            uid: user.uid,
            displayName: user.displayName,
            photoUrl: user.photoUrl,
          );
  }

  @override
  Stream<UserAuth> get onAuthStateChanged {
    return _fireBaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<UserAuth> currentUser() async {
    final user = await _fireBaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<UserAuth> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _fireBaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (!authResult.user.isEmailVerified) {
      throw PlatformException(
          code: 'ERROR_EMAIL_NOT_VERIFIED',
          message:
              'Please verify your email address by clicking on the link emailed to you.');
    } else {
      return _userFromFirebase(authResult.user);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _fireBaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // TODO Hotmail filters verification email sent by Firebase
    authResult.user.sendEmailVerification();
    throw PlatformException(
        code: 'EMAIL_NOT_VERIFIED',
        message:
            'Please verify your email address by clicking on the link emailed to you.');
  }

  @override
  Future<void> resetPassword(String email) async {
    await _fireBaseAuth.sendPasswordResetEmail(email: email);
    throw PlatformException(
        code: 'PASSWORD_RESET',
        message:
            'A password reset link has been emailed to you. Please click on it to enter your new password and try to sign in again.');
  }

  @override
  Future<void> signOut() async {
    await _fireBaseAuth.signOut();
  }
}
