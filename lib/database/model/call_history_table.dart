import 'package:floor/floor.dart';

@entity
class CallHistoryTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String userPicUrl;
  final String callerName;
  final String callType;
  final bool isIncomingCall;
  final bool isMissedCall;
  final String date;
  final String callTime;
  final String endCallTime;
  final String totalCallTime;

  CallHistoryTable(this.userPicUrl,this.callerName, this.callType, this.isIncomingCall,
      this.isMissedCall,this.date,this.callTime,this.endCallTime,this.totalCallTime);
}
