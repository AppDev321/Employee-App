import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/response/report_leave_response.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../utils/controller.dart';

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
    Controller().printLogs(chartData.toString());
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
          legendIconType: LegendIconType.rectangle,
          xValueMapper: (ChartData data, _) => Controller().capitalize(data.name.toString().toLowerCase()) ,
          yValueMapper: (ChartData data, _) => data.count,
          dataLabelMapper: (ChartData data, _) =>   Controller().capitalize(data.name.toString().toLowerCase()) +"\n"+data.count.toString(),
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,

              labelPosition:ChartDataLabelPosition.outside
          )
      ),
    ];
  }

}

