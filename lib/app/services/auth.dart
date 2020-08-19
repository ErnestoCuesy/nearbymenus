import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class UserAuth {
  UserAuth({
    @required this.uid,
    @required this.photoUrl,
    @required this.displayName,
    @required this.email,
    @required this.isAnonymous,
    @required this.isEmailVerified,
  });
  final String uid;
  final String photoUrl;
  final String displayName;
  final String email;
  final bool isAnonymous;
  final bool isEmailVerified;
}

abstract class AuthBase {
  Stream<UserAuth> get onAuthStateChanged;
  Future<UserAuth> currentUser();
  Future<UserAuth> signInAnonymously();
  Future<UserAuth> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<void> convertUserWithEmail(String email, String password, String name);
  Future<void> updateUserName(String name, FirebaseUser currentUser);
  Future<bool> userIsAnonymous();
  Future<bool> userEmailVerified();
  Future<void> sendEmailVerification();
  Future<void> reloadUser();
  Future<String> userEmail();
  Future<void> deleteUser();
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
            email: user.email,
            photoUrl: user.photoUrl,
            isAnonymous: user.isAnonymous,
            isEmailVerified: user.isEmailVerified
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
  Future<UserAuth> signInAnonymously() async {
    final authResult = await _fireBaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
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
    final currentUser = await _fireBaseAuth.currentUser();
    final credential = EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  @override
  Future<void> updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  @override
  Future<bool> userIsAnonymous() async {
    return await _fireBaseAuth.currentUser().then((value) => value.isAnonymous);
  }

  @override
  Future<bool> userEmailVerified() async {
    try {
      return await _fireBaseAuth.currentUser().then((value) => value.isEmailVerified);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final currentUser = await _fireBaseAuth.currentUser();
    await currentUser.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() async {
    final currentUser = await _fireBaseAuth.currentUser();
    try {
      await currentUser.reload();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<String> userEmail() async {
    return await _fireBaseAuth.currentUser().then((value) => value.email);
  }

  @override
  Future<void> deleteUser() async {
    try {
      final user = await _fireBaseAuth.currentUser();
      user.delete();
    } catch (e) {
      print(e);
    }
  }
}
