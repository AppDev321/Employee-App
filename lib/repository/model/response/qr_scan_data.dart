class QrScanData {
  String? code;
  String? type;

  QrScanData({this.code, this.type});

  QrScanData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    return data;
  }

}