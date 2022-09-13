import 'package:connected_shirt/services/network_service/shirt_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// StatefulWidget ShirtDataPage to create our ShirtDataWidget.
///
/// The ShirtDataWidget is the widget in which we show our live data.
/// We show a listview with the Time, Heart beat, Temperature and Humidity.
class ShirtDataWidget extends StatefulWidget {
  const ShirtDataWidget({Key? key}) : super(key: key);

  @override
  _ShirtDataWidgetState createState() => _ShirtDataWidgetState();
}

class _ShirtDataWidgetState extends State<ShirtDataWidget>
    with AutomaticKeepAliveClientMixin {
  List<String> _favorites = ["00:00", "0", "0", "0"];

  final List<String> _values = [
    LocaleKeys.time.tr(),
    LocaleKeys.heartBeat.tr(),
    LocaleKeys.temperature.tr(),
    LocaleKeys.humidity.tr()
  ];
  final List<String> _units = ["", " bpm", " °C", "%"];
  final List<Icon> _icons = [
    const Icon(Icons.watch_later, size: 50),
    const Icon(Icons.favorite, color: Colors.red, size: 50),
    const Icon(Icons.ac_unit, color: Colors.blue, size: 50),
    const Icon(Icons.water, color: Colors.blue, size: 50)
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _favorites = context.watch<ShirtService>().measures;
    return ListView.builder(
        itemCount: _favorites.length + 1,
        itemBuilder: (BuildContext context, index) {
          if (index == _favorites.length) {
            if (context.read<ShirtService>().isFetchingData) {
              return Center(
                  child: Column(children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.stop),
                    color: Colors.white,
                    onPressed: () {
                      context.read<ShirtService>().stopFetchingData();
                      setState(() {});
                    },
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: const Text(LocaleKeys.stopFetchingData).tr())
              ]));
            } else {
              return Center(
                  child: Column(children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    color: Colors.white,
                    onPressed: () =>
                        context.read<ShirtService>().startFetchingData(),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: const Text(LocaleKeys.startFetchingData).tr())
              ]));
            }
          }
          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(children: [
              ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  _favorites[index] + _units[index],
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 30.0),
                ),
                subtitle: Text(_values[index]),
                trailing: _icons[index],
              ),
            ]),
          );
        });
  }
}
