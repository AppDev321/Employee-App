import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/response/report_leave_response.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class  DoughnutChart extends StatefulWidget {
  DoughnutChart({
    Key? key,
    required this.chartData,
  }) : super(key: key);

  final List<ChartData> chartData;


  @override
  DoughnutChartState createState() => DoughnutChartState();
}

class DoughnutChartState extends State<DoughnutChart> {
  List<ChartData> chartData = [];
  @override
  Widget build(BuildContext context) {
    chartData = widget.chartData;
    print(chartData.toString());
    return  _buildDefaultPieChart();
  }


  /// Returns the circular  chart with pie series.
  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
     legend: Legend(isVisible: true),
      series: _getDefaultPieSeries(),
    );
  }

  /// Returns the pie series.
  List<PieSeries<ChartData, String>> _getDefaultPieSeries() {
    return  <PieSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.name.toString() as String,
          yValueMapper: (ChartData data, _) => data.count,
          dataLabelMapper: (ChartData data, _) => data.name,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: false)),
    ];
  }

}

