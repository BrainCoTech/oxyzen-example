import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../device_provider.dart';
import 'eeg_chart.dart';

class MeditationChart extends StatelessWidget {
  const MeditationChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(12),
        color: Theme.of(context).primaryColor.withAlpha(0x15),
        child: ChangeNotifierProvider(
            create: (context) => DeviceProvider(),
            child: Consumer<DeviceProvider>(
                builder: (context, provider, _) => Builder(
                      builder: (context) {
                        return LineChart(
                          LineChartData(
                              gridData: FlGridData(
                                  checkToShowHorizontalLine: (value) {
                                return value == 35 || value == 65;
                              }),
                              titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      if (value == 35.0 || value == 65.0) {
                                        return Text(meta.formattedValue);
                                      }
                                      return const Text('');
                                    },
                                  )),
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 60,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      return Text(
                                          (value.round() ~/ 60).toString());
                                    },
                                  ))),
                              borderData: FlBorderData(
                                  border: const Border(
                                      left: BorderSide(),
                                      bottom: BorderSide())),
                              maxX: provider.duration.toDouble(),
                              minX: 0,
                              minY: 0,
                              maxY: 100,
                              lineBarsData: [
                                LineChartBarData(
                                    spots: toSpots(provider.chartValues),
                                    color: Colors.blue,
                                    dotData: FlDotData(show: false))
                              ]),
                          swapAnimationDuration: const Duration(seconds: 0),
                        );
                      },
                    ))));
  }
}
