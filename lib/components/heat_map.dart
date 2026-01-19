import 'package:bene/datetime/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateDDMMYY;

  const MyHeatMap({
      super.key,
      required this.datasets,
      required this.startDateDDMMYY,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateDDMMYY),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey,
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 35,
        colorsets: const {
          1: Colors.lightGreenAccent,
          2: Colors.lightGreen,
          3: Colors.green,
        },

      ),
    );
  }
}