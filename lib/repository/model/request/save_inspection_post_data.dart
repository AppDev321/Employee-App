import 'package:json_annotation/json_annotation.dart';

import '../response/get_inspection_check_api_response.dart';

part 'save_inspection_post_data.g.dart';

@JsonSerializable()
class PostInspectionData {
  int? inspectionId;
  List<Checks>? checks;

  PostInspectionData({this.inspectionId, this.checks});

  PostInspectionData.fromJson(Map<String, dynamic> json) {
    inspectionId = json['inspection_id'];
    if (json['checks'] != null) {
      checks = <Checks>[];
      json['checks'].forEach((v) {
        checks!.add(new Checks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inspection_id'] = this.inspectionId;
    if (this.checks != null) {
      data['checks'] = this.checks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
