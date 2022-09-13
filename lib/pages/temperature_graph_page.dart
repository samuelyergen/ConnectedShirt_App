import 'package:connected_shirt/services/firebase_service/data_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// StatefulWidget that represents our Temperature graph.
///
/// Class for the graph of the temperature
/// This class is using a SfCartesianChart for drawing the chart
class TemperatureGraphPage extends StatefulWidget {
  const TemperatureGraphPage({Key? key}) : super(key: key);

  @override
  State<TemperatureGraphPage> createState() => _TemperatureGraphPageState();
}

class _TemperatureGraphPageState extends State<TemperatureGraphPage> {
  List<TempDetails> temps = [];
  late TooltipBehavior _tooltipBehavior;

  Future<List> getJsonFromAssets() async {
    return await context.read<DataService>().getData();
  }

  Future loadTempData() async {
    final dynamic jsonResponse = await context.read<DataService>().getTMP();
    for (Map<dynamic, dynamic> i in jsonResponse) {
      temps.add(TempDetails.fromJson(i));
    }

    temps.sort((a, b) => a.time.compareTo(b.time));
  }

  @override
  void initState() {
    loadTempData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final element = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title:
              Text(LocaleKeys.graph.tr() + ' ' + LocaleKeys.temperature.tr() + ' ' + element.toString()),
        ),
        body: Center(
            child: FutureBuilder(
          future: getJsonFromAssets(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: LocaleKeys.temperature.tr()),
                  series: <ChartSeries>[
                    LineSeries<TempDetails, String>(
                        name: "Temperature",
                        enableTooltip: true,
                        dataSource: temps
                            .where((i) => i.date.contains(element.toString()))
                            .toList(),
                        xValueMapper: (TempDetails details, _) => details.time,
                        yValueMapper: (TempDetails details, _) =>
                            int.parse(details.temperature))
                  ]));
            } else {
              return Card(
                elevation: 5.0,
                child: SizedBox(
                  height: 100,
                  width: 400,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(LocaleKeys.loading,
                            style: TextStyle(fontSize: 20.0)).tr(),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            semanticsLabel: LocaleKeys.loading.tr(),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        )));
  }
}

/// Class that represents the TempDetails for our temperature graph.
///
/// This class will help about the details of the frequency of the frequency
/// widget.
class TempDetails {
  final String time;
  final String temperature;
  final String date;

  TempDetails(this.time, this.temperature, this.date);

  factory TempDetails.fromJson(Map<dynamic, dynamic> parsedJson) {
    return TempDetails(parsedJson['time'].toString(),
        parsedJson['tmp'].toString(), parsedJson['date'].toString());
  }
}
