import 'package:connected_shirt/pages/home_page.dart';
import 'package:connected_shirt/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// StatelessWidget that represents our AuthenticationWrapper.
///
/// It enables us to "route" the HomePage or SignInPage for the User.
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      context.watch<User>();
      return const HomePage();
    } on ProviderNullException {
      return const SignInPage();
    }
  }
}
