import 'package:connected_shirt/services/ui_service/theme_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// StatelessWidget AboutPage to create our AboutPage.
///
/// The AboutPage is the page in which the user can see information about
/// the application and his creators.
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.aboutUs.tr()),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
          child: Text(
            LocaleKeys.aboutText.tr(),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: context.read<ThemeService>().isDarkMode
                  ? Colors.white
                  : Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
        const Expanded(
          child: Image(
              image: AssetImage("assets/images/hevslogo.png"),
              width: 300
          ),
        )
      ]),
    );
  }
}
