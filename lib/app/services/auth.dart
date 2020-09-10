import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class UserAuth {
  UserAuth({
    @required this.uid,
    @required this.photoURL,
    @required this.displayName,
    @required this.email,
    @required this.isAnonymous,
    @required this.isEmailVerified,
  });
  final String uid;
  final String photoURL;
  final String displayName;
  final String email;
  final bool isAnonymous;
  final bool isEmailVerified;
}

abstract class AuthBase {
  Stream<UserAuth> get authStateChanges;
  Future<UserAuth> currentUser();
  Future<UserAuth> signInAnonymously();
  Future<UserAuth> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<void> convertUserWithEmail(String email, String password, String name);
  Future<void> updateUserName(String name, User currentUser);
  Future<bool> userIsAnonymous();
  Future<bool> userEmailVerified();
  Future<void> sendEmailVerification();
  Future<void> reloadUser();
  Future<String> userEmail();
  Future<void> deleteUser();
}

class Auth implements AuthBase {
  final _fireBaseAuth = FirebaseAuth.instance;

  UserAuth _userFromFirebase(User user) {
    print('User => ${user.displayName}');
    return user == null
        ? null
        : UserAuth(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            photoURL: user.photoURL,
            isAnonymous: user.isAnonymous,
            isEmailVerified: user.emailVerified
          );
  }

  @override
  Stream<UserAuth> get authStateChanges {
    return _fireBaseAuth.authStateChanges().map((event) => _userFromFirebase(event));
  }

  @override
  Future<UserAuth> currentUser() async {
    final user = _fireBaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<UserAuth> signInAnonymously() async {
    final authResult = await _fireBaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserAuth> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _fireBaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (!authResult.user.emailVerified) {
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
    // Hotmail filters verification email sent by Firebase - avoid Hotmail
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
  @override
  Future<void> convertUserWithEmail(String email, String password, String name) async {
    final currentUser = _fireBaseAuth.currentUser;
    final credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  @override
  Future<void> updateUserName(String name, User currentUser) async {
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  @override
  Future<bool> userIsAnonymous() async {
    return _fireBaseAuth.currentUser.isAnonymous;
  }

  @override
  Future<bool> userEmailVerified() async {
    return _fireBaseAuth.currentUser.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    _fireBaseAuth.currentUser.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() async {
    try {
      _fireBaseAuth.currentUser.reload();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<String> userEmail() async {
    return _fireBaseAuth.currentUser.email;
  }

  @override
  Future<void> deleteUser() async {
    try {
      _fireBaseAuth.currentUser.delete();
    } catch (e) {
      print(e);
    }
  }
}
