import 'package:floor/floor.dart';

@entity
class CallHistoryTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
   String callerID;
   String userPicUrl;
   String callerName;
   String callType;
   bool isIncomingCall;
   bool isMissedCall;
   String date;
   String callTime;
   String endCallTime;
   String totalCallTime;

  CallHistoryTable(this.callerID,this.userPicUrl,this.callerName, this.callType, this.isIncomingCall,
      this.isMissedCall,this.date,this.callTime,this.endCallTime,this.totalCallTime);
}
