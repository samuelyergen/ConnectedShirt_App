import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Class that represents our PasswordField.
class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isObscure;
  final Function() updateObscurity;

  const PasswordFieldWidget(
      this.passwordController, this.isObscure, this.updateObscurity,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: passwordController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: LocaleKeys.password.tr(),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            tooltip: isObscure
                ? LocaleKeys.showPassword.tr()
                : LocaleKeys.hidePassword.tr(),
            onPressed: updateObscurity,
            icon: Icon(
              isObscure ? Icons.visibility : Icons.visibility_off,
//                         color: Colors.grey,
            ),
          ),
        ),
        obscureText: isObscure,
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }
}
