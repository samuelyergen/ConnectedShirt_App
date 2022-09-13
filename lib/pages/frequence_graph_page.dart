import 'package:connected_shirt/services/firebase_service/data_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Stateful widget that represents our FrequencyGraphPage.
///
/// Class for the graph of the frequency
/// This class is using a SfCartesianChart for drawing the chart
class FrequencyGraphPage extends StatefulWidget {
  const FrequencyGraphPage({Key? key}) : super(key: key);

  @override
  State<FrequencyGraphPage> createState() => _FrequencyGraphPageState();
}

class _FrequencyGraphPageState extends State<FrequencyGraphPage> {
  List<FrequencyDetail> frequencies = [];
  late TooltipBehavior _tooltipBehavior;

  Future<List> getJsonFromAssets() async {
    return await context.read<DataService>().getBPM();
  }

  Future loadTempData() async {
    final dynamic jsonResponse = await context.read<DataService>().getBPM();
    for (Map<dynamic, dynamic> i in jsonResponse) {
      frequencies.add(FrequencyDetail.fromJson(i));
    }
    frequencies.sort((a, b) => a.time.compareTo(b.time));
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    loadTempData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final element = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.graph.tr() +
            ' ' +
            LocaleKeys.heartBeat.tr() +
            ' ' +
            element.toString()),
      ),
      body: Center(
        child: FutureBuilder(
          future: getJsonFromAssets(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: LocaleKeys.heartBeat.tr()),
                  series: <ChartSeries>[
                    LineSeries<FrequencyDetail, String>(
                        name: "BPM",
                        enableTooltip: true,
                        dataSource: frequencies
                            .where((i) => i.date.contains(element.toString()))
                            .toList(),
                        xValueMapper: (FrequencyDetail details, _) =>
                            details.time,
                        yValueMapper: (FrequencyDetail details, _) =>
                            int.parse(details.frequency))
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
        ),
      ),
    );
  }
}

/// Class that represents the FrequencyDetails for our frequency graph.
///
/// This class will help about the details of the frequency of the frequency
/// widget.
class FrequencyDetail {
  final String time;
  final String frequency;
  final String date;

  FrequencyDetail(this.time, this.frequency, this.date);

  factory FrequencyDetail.fromJson(Map<dynamic, dynamic> parsedJson) {
    return FrequencyDetail(parsedJson['time'].toString(),
        parsedJson['bpm'].toString(), parsedJson['date'].toString());
  }
}
