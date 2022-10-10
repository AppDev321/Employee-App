import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/widget/pie_chart_indicator.dart';

import '../repository/model/response/report_leave_response.dart';

class PieChartWidget extends StatefulWidget {
  PieChartWidget({
    Key? key,
    required this.chartData,
  }) : super(key: key);

  final List<ChartData> chartData;

  @override
  State<StatefulWidget> createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
   List<ChartData> chartData = [];

  @override
  Widget build(BuildContext context) {
    chartData = widget.chartData;
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AspectRatio(
                aspectRatio:1.8,
                child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 1,
                        centerSpaceRadius: 50,
                        sections: showingSections()),
                  ),
              ),

             Container(
               padding: const EdgeInsets.only(left:10,right: 10,top:20,bottom: 10),
                  child:
                  Wrap(
                    children:chartData.asMap().keys.map((index){
                      return
                        chartData[index].count! >0 ?
                        Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(3),
                            child:Indicator(
                              color: colorArray[index],
                              text: chartData[index].name.toString(),
                              isSquare: true,
                            ),
                          ),
                        ],
                      ):const Center();
                    }).toList(),
                  )
                ),
          ],


    );
  }

 /* @override
  Widget build(BuildContext context) {
    chartData = widget.chartData;
    return AspectRatio(
      aspectRatio: 1/2,
      child:  Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(touchCallback:
                      (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse
                          .touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 1,
                  centerSpaceRadius: 50,
                  sections: showingSections()),
            ),

          ),
          Expanded(
            flex: 2,
            child: Container(
              child:
              ListView.builder(
                shrinkWrap: true, //just set this property
                itemCount: chartData.length,
                itemBuilder: (context, index) =>
                    Column(

                        children: [
                          Indicator(
                            color: colorArray[index],
                            text: chartData[index].name.toString(),
                            isSquare: false,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                        ]),
              ),
            ),
          ),



        ],
      ),

    );
  }*/


  List<PieChartSectionData> showingSections() {
    return List.generate(chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: colorArray[i],
        value: chartData[i].count?.toDouble(),
        title: chartData[i].count.toString(),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: const Color(0xffffffff)),
      );
    });
  }
}
