class SocketMessageModel {
  String? type;
  String? callerName;
  String? sendTo;
  String? sendFrom;
  dynamic data;

  SocketMessageModel({this.type, this.callerName, this.sendTo, this.data,this.sendFrom});

  SocketMessageModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    callerName = json['callerName'];
    sendTo = json['sendTo'];
    data = json['data'];
    sendFrom = json['sendFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['callerName'] = this.callerName;
    data['sendTo'] = this.sendTo;
    data['data'] = this.data;
    data['sendFrom'] = this.sendFrom;
    return data;
  }
}
