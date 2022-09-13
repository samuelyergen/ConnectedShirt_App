import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Class that represents our Email Field.
class EmailFieldWidget extends StatelessWidget {
  final TextEditingController emailController;

  const EmailFieldWidget(this.emailController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          border: const OutlineInputBorder(),
          labelText: LocaleKeys.emailAddress.tr(),
        ),
      ),
    );
  }
}
