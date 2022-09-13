import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:connected_shirt/widget/authentication_widgets/authentication_wrapper_widget.dart';
import 'package:connected_shirt/widget/settings_widgets/dark_mode_setting_widget.dart';
import 'package:connected_shirt/widget/settings_widgets/language_selection_setting_widget.dart';
import 'package:connected_shirt/widget/settings_widgets/shirt_refresh_setting_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// StatelessWidget SettingsPage to create our SettingsPage.
///
/// The SettingsPage is the page in which the user can control his different
/// settings such as dark mode, language or shirt settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.settings).tr(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const AuthenticationWrapper())),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            DarkModeWidget(),
            LanguageSelectionWidget(),
            ShirtRefreshRateSelectionWidget(),
          ],
        ),
      ),
    );
  }
}
