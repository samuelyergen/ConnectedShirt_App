import 'package:connected_shirt/pages/about_page.dart';
import 'package:connected_shirt/pages/contact_page.dart';
import 'package:connected_shirt/pages/settings_page.dart';
import 'package:connected_shirt/pages/temperature_graph_page.dart';
import 'package:connected_shirt/services/firebase_service/authentication_service.dart';
import 'package:connected_shirt/services/firebase_service/data_service.dart';
import 'package:connected_shirt/services/network_service/shirt_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:connected_shirt/widget/shirt_data_widgets/shirt_data_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frequence_graph_page.dart';
import 'humidity_graph_page.dart';

/// StatelessWidget HomePage to create our HomePage.
///
/// The HomePage shows after User Connection.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String currentUserMail =
        FirebaseAuth.instance.currentUser!.email.toString();
    String currentUsername =
        currentUserMail.substring(0, currentUserMail.indexOf("@"));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.hello.tr() + " " + currentUsername + "!"),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            tabs: [
              Tab(
                icon: const Icon(Icons.scatter_plot),
                text: LocaleKeys.historicalData.tr(),
              ),
              Tab(
                icon: const Icon(Icons.stream),
                text: LocaleKeys.liveData.tr(),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              onSelected: (result) {
                switch (result) {
                  case 0:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutPage()),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactPage()),
                    );
                    break;
                  case 3:
                    context.read<ShirtService>().stopFetchingData();
                    context.read<AuthenticationService>().signOut();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {
                  LocaleKeys.settings.tr(),
                  LocaleKeys.aboutUs.tr(),
                  LocaleKeys.contactReport.tr(),
                  LocaleKeys.signOut.tr()
                }.toList().asMap().entries.map((choice) {
                  return PopupMenuItem<int>(
                    value: choice.key,
                    child: Text(choice.value),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: const TabBarView(
          children: [_FirstTabWidgetTemp(), ShirtDataWidget()],
        ),
      ),
    );
  }
}

class _FirstTabWidgetTemp extends StatefulWidget {
  const _FirstTabWidgetTemp({Key? key}) : super(key: key);

  @override
  _FirstTabWidgetTempState createState() => _FirstTabWidgetTempState();
}

class _FirstTabWidgetTempState extends State<_FirstTabWidgetTemp>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<String> _dates = [];

  Future<void> initDates() async {
    await context.read<DataService>().getDate().then((value) {
      if (mounted) {
        setState(() {
          _dates = [
            ...{...value}
          ];
        });
      }
    });
  }

  @override
  bool get mounted {
    return super.mounted;
  }

  List<Widget> displayDate() {
    List<Widget> list = [];
    for (String element in _dates) {
      list.add(ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          element,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 30.0),
        ),
        subtitle: const Text(LocaleKeys.activityOn).tr(),
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FrequencyGraphPage(),
                    settings: RouteSettings(
                      arguments: element,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.ac_unit, color: Colors.blue, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TemperatureGraphPage(),
                    settings: RouteSettings(
                      arguments: element,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.water, color: Colors.blue, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HumidityGraphPage(),
                    settings: RouteSettings(
                      arguments: element,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    initDates();
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(children: displayDate().toList()),
              );
            },
          ),
        ],
      ),
    );
  }
}
