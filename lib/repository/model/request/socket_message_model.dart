class SocketMessageModel {
  String? type;
  String? callerName;
  String? sendTo;
  String? sendFrom;
  String? callType;
  String? offerConnectionId;
  dynamic data;

  SocketMessageModel({this.type, this.callerName, this.sendTo, this.data,this.sendFrom,this.offerConnectionId,this.callType});

  SocketMessageModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    callerName = json['callerName'];
    sendTo = json['sendTo'];
    data = json['data'];
    sendFrom = json['sendFrom'];
    callType = json['callType'];
    offerConnectionId = json['offer_connection_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['callerName'] = this.callerName;
    data['sendTo'] = this.sendTo;
    data['data'] = this.data;
    data['sendFrom'] = this.sendFrom;
    data['callType'] = this.callType;
    data['offer_connection_id']= this.offerConnectionId;
    return data;
  }
}

class UserCallingStatus {
  bool? isOnline;
  bool? isBusy;
  UserCallingStatus({this.isOnline, this.isBusy});
  UserCallingStatus.fromJson(Map<String, dynamic> json) {
    isOnline = json['is_online'];
    isBusy = json['is_busy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['is_online'] = this.isOnline;
    data['is_busy'] = this.isBusy;
    return data;
  }
}
