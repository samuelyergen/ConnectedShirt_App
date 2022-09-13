import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The LanguageSelectionWidget represents a setting.
///
/// The LanguageSelectionWidget represents a setting in our SettingsPage.
/// It enables the user to switch between different languages.
class LanguageSelectionWidget extends StatefulWidget {
  const LanguageSelectionWidget({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionWidget> createState() =>
      _LanguageSelectionWidgetState();
}

class _LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  String dropdownValue = "English";

  @override
  Widget build(BuildContext context) {
    switch (context.locale.toString()) {
      case "en":
        dropdownValue = "English";
        break;
      case "fr":
        dropdownValue = "Français";
        break;
      case "de":
        dropdownValue = "Deutsch";
        break;
      default:
        dropdownValue = "English";
        break;
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(27, 0, 34, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            LocaleKeys.language,
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ).tr(),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(
              Icons.language,
              color: Colors.blue,
            ),
            style: const TextStyle(color: Colors.blue),
            onChanged: (String? newLanguage) {
              switch (newLanguage) {
                case "English":
                  context.setLocale(const Locale("en"));
                  break;
                case "Français":
                  context.setLocale(const Locale("fr"));
                  break;
                case "Deutsch":
                  context.setLocale(const Locale("de"));
                  break;
                default:
                  context.setLocale(const Locale("en"));
                  break;
              }

              setState(() {
                dropdownValue = newLanguage!;
              });
            },
            items: <String>["English", "Français", "Deutsch"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
