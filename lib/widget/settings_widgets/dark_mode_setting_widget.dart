import 'package:connected_shirt/services/ui_service/theme_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The DarkModeWidget represents a setting.
///
/// The DarkModeWidget represents a setting in our SettingsPage. It enables
/// the user to switch between dark and light mode.
class DarkModeWidget extends StatelessWidget {
  const DarkModeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SwitchListTile(
              subtitle: const Text(LocaleKeys.switchTo).tr(),
              activeColor: Colors.blue,
              title: context.read<ThemeService>().isDarkMode
                  ? const Text(
                      LocaleKeys.lightMode,
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ).tr()
                  : const Text(
                      LocaleKeys.darkMode,
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ).tr(),
              onChanged: (_) {
                context.read<ThemeService>().toggleMode();
              },
              value: context.watch<ThemeService>().isDarkMode,
            )
          ],
        ));
  }
}
