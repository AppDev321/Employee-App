import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';

import '../../../custom_style/strings.dart';
import '../../../database/model/call_history_table.dart';
import '../../../repository/model/response/contact_list.dart';
import '../../../widget/custom_text_widget.dart';
import '../../../widget/error_message.dart';
import '../../videocall/video_call_screen.dart';

class CallHistoryListWidget extends StatefulWidget {
  final dynamic futureFunction;

  CallHistoryListWidget({required this.futureFunction});

  @override
  _CallHistoryListWidgetState createState() => _CallHistoryListWidgetState();
}

class _CallHistoryListWidgetState extends State<CallHistoryListWidget> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.futureFunction,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorMessageWidget(label: "${snapshot.error}");
        } else if (snapshot.hasData) {
          var callHistoryList = snapshot.data as List<CallHistoryTable>;
          return
            callHistoryList.isNotEmpty?
            ListView.builder(
            itemCount: callHistoryList.length,
            itemBuilder: (context, index) {
              var item = callHistoryList[index];
              return ListTile(
                title: Text(item.callerName.toString()),
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  child:FittedBox(
                    child: CustomTextWidget(text:item.callerName
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),color: Colors.white,),
                  )  ,
                ),
                subtitle: Text("${item.date} ${item.callTime}  ${item.isIncomingCall?"Incoming":"Outgoing" }"),
              );
            },
          ): const Expanded(child:
            Center(child:  CustomTextWidget(text: ConstantData.noDataFound,textAlign: TextAlign.center)));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
