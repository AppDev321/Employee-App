class SocketMessageModel {
  String? type;
  String? callerName;
  String? sendTo;
  dynamic data;

  SocketMessageModel({this.type, this.callerName, this.sendTo, this.data});

  SocketMessageModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    callerName = json['callerName'];
    sendTo = json['sendTo'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['callerName'] = this.callerName;
    data['sendTo'] = this.sendTo;
    data['data'] = this.data;
    return data;
  }
}