import 'package:connected_shirt/pages/onboarding_page.dart';
import 'package:connected_shirt/services/firebase_service/authentication_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:connected_shirt/widget/signin_signup_widgets/email_field_widget.dart';
import 'package:connected_shirt/widget/signin_signup_widgets/password_field_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Stateful SignUpPage to create our SignUpPage.
///
/// The SignUpPage shows at the start, it enables the user to sign up.
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  void _updateObscurity() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  /// Method to show Alert Dialog Box on sign up errors.
  ///
  /// Method that will show an alert box in the screen if an error appears in
  /// the sign up process.
  void showAlert(newMessage) {
    if (newMessage != "Signed up") {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ),
          title: const Text(LocaleKeys.somethingWentWrong).tr(),
          content: Text(newMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(LocaleKeys.ok).tr(),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Shirt - " + LocaleKeys.group.tr() + " 4"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  LocaleKeys.createAccount,
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ).tr()),
            EmailFieldWidget(emailController),
            PasswordFieldWidget(
                passwordController, _isObscure, _updateObscurity),
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                child: const Text(LocaleKeys.createAccount).tr(),
                onPressed: () {
                  context
                      .read<AuthenticationService>()
                      .signUp(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      )
                      .then((value) => showAlert(value));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
