import 'package:connected_shirt/services/firebase_service/data_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// StatefulWidget that represents our HumidityGraph.
///
/// Class for the graph of the humidity
/// This class is using a SfCartesianChart for drawing the chart
class HumidityGraphPage extends StatefulWidget {
  const HumidityGraphPage({Key? key}) : super(key: key);

  @override
  State<HumidityGraphPage> createState() => _HumidityGraphPageState();
}

class _HumidityGraphPageState extends State<HumidityGraphPage> {
  List<HumidityDetails> humidities = [];
  late TooltipBehavior _tooltipBehavior;

  Future<List> getJsonFromAssets() async {
    return await context.read<DataService>().getData();
  }

  Future loadTempData() async {
    final dynamic jsonResponse = await context.read<DataService>().getHMD();
    for (Map<dynamic, dynamic> i in jsonResponse) {
      humidities.add(HumidityDetails.fromJson(i));
    }

    humidities.sort((a, b) => a.time.compareTo(b.time));
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
          title: Text(LocaleKeys.graph.tr() + ' ' + LocaleKeys.humidity.tr() + ' ' + element.toString()),
        ),
        body: Center(
            child: FutureBuilder(
          future: getJsonFromAssets(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: LocaleKeys.humidity.tr()),
                  series: <ChartSeries>[
                    LineSeries<HumidityDetails, String>(
                        name: "Humidity",
                        enableTooltip: true,
                        dataSource: humidities
                            .where((i) => i.date.contains(element.toString()))
                            .toList(),
                        xValueMapper: (HumidityDetails details, _) =>
                            details.time,
                        yValueMapper: (HumidityDetails details, _) =>
                            int.parse(details.humidity))
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

/// Class that represents the HumidityDetails for our humidity graph.
///
/// This class will help about the details of the humidity of the humidity
/// widget.
class HumidityDetails {
  final String time;
  final String humidity;
  final String date;

  HumidityDetails(this.time, this.humidity, this.date);

  factory HumidityDetails.fromJson(Map<dynamic, dynamic> parsedJson) {
    return HumidityDetails(parsedJson['time'].toString(),
        parsedJson['hmd'].toString(), parsedJson['date'].toString());
  }
}
