import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Class that represents the AuthenticationService.
class AuthenticationService {
  /// FirebaseAuth object of our AuthenticationService class.
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Getter for the authenticated state.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Method to sign out from the application.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Method to sign in to the application.
  ///
  /// Return a String "Signed in" if the user correctly signed in or an
  /// error message as String.
  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return LocaleKeys.invalidEmail.tr();
        case "user-disabled":
          return LocaleKeys.userDisabled.tr();
        case "user-not-found":
          return LocaleKeys.userNotFound.tr();
        case "wrong-password":
          return LocaleKeys.wrongPassword.tr();
      }
      return LocaleKeys.checkYourEntries.tr();
    }
  }

  /// Method to sign up to the application.
  ///
  /// Return a String "Signed up" if the user correctly signed up or an
  /// error message as String.
  Future<String?> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return LocaleKeys.invalidEmail.tr();
        case "email-already-in-use":
          return LocaleKeys.emailAlreadyInUse.tr();
        case "operation-not-allowed":
          return LocaleKeys.operationNotAllowed.tr();
        case "weak-password":
          return LocaleKeys.weakPassword.tr();
      }
      return LocaleKeys.checkYourEntries.tr();
    }
  }
}
