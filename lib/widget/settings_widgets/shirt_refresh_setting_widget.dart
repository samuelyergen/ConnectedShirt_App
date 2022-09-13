import 'package:connected_shirt/services/network_service/shirt_service.dart';
import 'package:connected_shirt/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The ShirtRefreshRateSelectionWidget represents a setting.
///
/// The ShirtRefreshRateSelectionWidget represents a setting in our
/// SettingsPage. It enables the user to switch between different languages.
class ShirtRefreshRateSelectionWidget extends StatefulWidget {
  const ShirtRefreshRateSelectionWidget({Key? key}) : super(key: key);

  @override
  _ShirtRefreshRateSelectionWidgetState createState() =>
      _ShirtRefreshRateSelectionWidgetState();
}

class _ShirtRefreshRateSelectionWidgetState
    extends State<ShirtRefreshRateSelectionWidget> {
  late int dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue = context.read<ShirtService>().shirtRefreshRate;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(27, 0, 34, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            LocaleKeys.refreshRate,
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ).tr(),
          DropdownButton<int>(
            value: dropdownValue,
            icon: const Icon(
              Icons.refresh,
              color: Colors.blue,
            ),
            style: const TextStyle(color: Colors.blue),
            onChanged: (int? newValue) {
              setState(() {
                context.read<ShirtService>().updateRefreshRate(newValue!);
              });
            },
            items: <int>[1, 5, 10, 30].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
