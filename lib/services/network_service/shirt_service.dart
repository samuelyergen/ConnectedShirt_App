import 'dart:async';
import 'dart:io';

import 'package:connected_shirt/services/firebase_service/data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

/// Class that represents the ShirtService.
class ShirtService with ChangeNotifier {
  int _shirtRefreshRate = 1;
  bool _isFetchingData = false;
  List<String> _measures = ["00:00", "0", "0", "0"];
  Timer? _timer;

  ShirtService();

  int get shirtRefreshRate => _shirtRefreshRate;

  bool get isFetchingData => _isFetchingData;

  List<String> get measures => _measures;

  /// Method to refresh the update rate of the t-shirt values.
  ///
  /// This method take a newValue in parameter and will change
  /// the update refreshRate of the t-shirt values.
  void updateRefreshRate(int newValue) {
    if (_isFetchingData) {
      _isFetchingData = false;
      _timer!.cancel();
      _shirtRefreshRate = newValue;
      startFetchingData();
    } else {
      _shirtRefreshRate = newValue;
    }
  }

  /// Method to start fetching the data.
  ///
  /// Fetch the data from the shirt each _shirtRefreshRate seconds.
  Future<void> startFetchingData() async {
    updateShirtMeasures();
    if (!_isFetchingData) {
      _timer = Timer.periodic(Duration(seconds: _shirtRefreshRate), (timer) {
        updateShirtMeasures();
      });
      _isFetchingData = true;
    }
  }

  /// Method to stop fetching the data.
  ///
  /// Stop fetching the data by stopping the timer.
  void stopFetchingData() {
    if (_timer != null) {
      _timer!.cancel();
      _isFetchingData = false;
    }
  }

  /// Method to update the measures from the shirt.
  ///
  /// Update the _measures that contains the live measures of the
  /// t-shirt.
  Future<void> updateShirtMeasures() async {
    bool hasContent = false;
    try {
      http.Response response;
      await NetworkInfo().getWifiIP().then((value) async {
        if (value.toString() == "192.168.4.101") {
          response = await http.get(Uri.parse('http://192.168.4.2/')).timeout(
              const Duration(seconds: 1),
              onTimeout: () => http.Response("", 408));
        } else {
          throw const SocketException("");
        }
        if (response.statusCode == 200) {
          hasContent = true;
          _measures = response.body.split(" ");
        } else {
          throw const SocketException("");
        }
      });
    } on SocketException {
      _measures = ["00:00", "0", "0", "0"];
      stopFetchingData();
    }
    if (hasContent) {
      DataService dataService = DataService();
      dataService.addActivity(_measures);
    }
    notifyListeners();
  }
}
