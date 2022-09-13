import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_shirt/services/firebase_service/authentication_service.dart';
import 'package:connected_shirt/services/firebase_service/data_service.dart';
import 'package:connected_shirt/services/network_service/shirt_service.dart';
import 'package:connected_shirt/services/ui_service/theme_service.dart';
import 'package:connected_shirt/translations/codegen_loader.g.dart';
import 'package:connected_shirt/widget/authentication_widgets/authentication_wrapper_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Main entry of our application.
///
/// The main function of our application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('de'), Locale('en'), Locale('fr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: const MyApp()),
  );
}

/// StatelessWidget MyApp to create our base widget.
///
/// MyApp widget that is Stateless that is the entry widget of our application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // redrawing all widgets after changing the language
  // https://github.com/aissat/easy_localization/issues/370
  // https://stackoverflow.com/questions/43778488/how-to-force-flutter-to-rebuild-redraw-all-widgets
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        Provider<DataService>(
          create: (_) => DataService(),
        ),
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ChangeNotifierProvider<ShirtService>(create: (_) => ShirtService()),
      ],
      child: Consumer<ThemeService>(
        builder: (_, model, __) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: "Connected Shirt",
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: model.mode,
            home: const AuthenticationWrapper(),
          );
        },
      ),
    );
  }
}
