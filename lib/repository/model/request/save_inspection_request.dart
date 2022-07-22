import 'package:json_annotation/json_annotation.dart';

part 'save_inspection_request.g.dart';

@JsonSerializable()
class SaveInspectionCheckRequest {
  List<SolvedChecked>? checks;

  SaveInspectionCheckRequest({this.checks});

  SaveInspectionCheckRequest.fromJson(Map<String, dynamic> json) {
    if (json['checks'] != null) {
      checks = <SolvedChecked>[];
      json['checks'].forEach((v) {
        checks!.add(new SolvedChecked.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.checks != null) {
      data['checks'] = this.checks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SolvedChecked {
  String? vehicleInspectionId;
  int? checkNo;
  String? name;
  String? type;
  String? code;
  String? comment;

  SolvedChecked(
      {this.vehicleInspectionId,
      this.checkNo,
      this.name,
      this.type,
      this.code,
      this.comment});

  SolvedChecked.fromJson(Map<String, dynamic> json) {
    vehicleInspectionId = json['vehicle_inspection_id'];
    checkNo = json['check_no'];
    name = json['name'];
    type = json['type'];
    code = json['code'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_inspection_id'] = this.vehicleInspectionId;
    data['check_no'] = this.checkNo;
    data['name'] = this.name;
    data['type'] = this.type;
    data['code'] = this.code;
    data['comment'] = this.comment;
    return data;
  }
}