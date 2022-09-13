import 'dart:convert';

import 'package:connected_shirt/services/ui_service/theme_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// StatelessWidget ContactPage to create our ContactPage.
///
/// The ContactPage is the page in which the user can contact the administrator
/// to report a bug or give a feedback.
class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  /// Method to show Alert Dialog Box on mail errors.
  ///
  /// Method that will show an alert box in the screen if an error appears in
  /// the sending mail process.
  void showAlert(title, newMessage) {
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
        title: Text(title),
        content: Text(newMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future sendEmail({
    required String message,
  }) async {
    const serviceId = 'service_6q87sih';
    const templateId = 'template_frmofln';
    const userId = 'user_FiGGMGrbSqvScW6luyexV';

    String email = FirebaseAuth.instance.currentUser!.email.toString();
    String name = email.substring(0, email.indexOf("@"));

    messageController.clear();

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        // pretend that the app is a web browser
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_message': message,
        }
      }),
    );

    if (response.body == "OK") {
      showAlert(LocaleKeys.thankYou.tr(), LocaleKeys.messageSent.tr());
    } else {
      showAlert(
          LocaleKeys.somethingWentWrong.tr(), LocaleKeys.messageNotSent.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.contactReport.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  LocaleKeys.sendMessage.tr(),
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 15.0),
              child: Text(
                LocaleKeys.contactText.tr(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: context.read<ThemeService>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: messageController,
                maxLines: 8,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.chat_bubble_rounded),
                  border: const OutlineInputBorder(),
                  labelText: LocaleKeys.message.tr(),
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                child: const Text(LocaleKeys.sendMessage).tr(),
                onPressed: () {
                  String message = messageController.text.trim();
                  if (message.isNotEmpty) {
                    sendEmail(message: message);
                  } else {
                    showAlert(LocaleKeys.somethingWentWrong.tr(),
                        LocaleKeys.pleaseEnterAMessage.tr());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
