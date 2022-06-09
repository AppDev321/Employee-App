import 'package:json_annotation/json_annotation.dart';

part 'get_inspection_check_api_response.g.dart';

//done this file

@JsonSerializable()
class GetInspectionCheckResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  GetInspectionCheckResponse({this.code, this.message, this.data, this.errors});

  GetInspectionCheckResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;

    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  String? message;

  Errors({this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Vehicle? vehicle;
  int? totalCount;
  Check? check;
  List<CheckOptions>? options;
  Inspection? inspection;

  Data(
      {this.vehicle,
      this.totalCount,
      this.check,
      this.options,
      this.inspection});

  Data.fromJson(Map<String, dynamic> json) {
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    totalCount = json['total_count'];
    check = json['check'] != null ? new Check.fromJson(json['check']) : null;
    if (json['options'] != null) {
      options = <CheckOptions>[];
      json['options'].forEach((v) {
        options!.add(new CheckOptions.fromJson(v));
      });
    }
    inspection = json['inspection'] != null
        ? new Inspection.fromJson(json['inspection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['total_count'] = this.totalCount;
    if (this.check != null) {
      data['check'] = this.check!.toJson();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.inspection != null) {
      data['inspection'] = this.inspection!.toJson();
    }
    return data;
  }
}

class Vehicle {
  int? id;
  int? employeeId;
  String? vrn;
  String? type;
  String? make;
  String? model;
  String? createdAt;
  String? updatedAt;
  Detail? detail;

  Vehicle(
      {this.id,
      this.employeeId,
      this.vrn,
      this.type,
      this.make,
      this.model,
      this.createdAt,
      this.updatedAt,
      this.detail});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    vrn = json['vrn'];
    type = json['type'];
    make = json['make'];
    model = json['model'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['vrn'] = this.vrn;
    data['type'] = this.type;
    data['make'] = this.make;
    data['model'] = this.model;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    return data;
  }
}

class Detail {
  int? id;
  int? vehicleId;
  String? purchaseCondition;
  String? purchaseDate;
  int? spareKey;
  String? roadStatus;
  String? vehicleType;
  int? isTrackerInstalled;
  Null? lastLocationLat;
  Null? lastLocationLong;
  Null? lastLocationTime;
  String? createdAt;
  String? updatedAt;

  Detail(
      {this.id,
      this.vehicleId,
      this.purchaseCondition,
      this.purchaseDate,
      this.spareKey,
      this.roadStatus,
      this.vehicleType,
      this.isTrackerInstalled,
      this.lastLocationLat,
      this.lastLocationLong,
      this.lastLocationTime,
      this.createdAt,
      this.updatedAt});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    purchaseCondition = json['purchase_condition'];
    purchaseDate = json['purchase_date'];
    spareKey = json['spare_key'];
    roadStatus = json['road_status'];
    vehicleType = json['vehicle_type'];
    isTrackerInstalled = json['isTrackerInstalled'];
    lastLocationLat = json['last_location_lat'];
    lastLocationLong = json['last_location_long'];
    lastLocationTime = json['last_location_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_id'] = this.vehicleId;
    data['purchase_condition'] = this.purchaseCondition;
    data['purchase_date'] = this.purchaseDate;
    data['spare_key'] = this.spareKey;
    data['road_status'] = this.roadStatus;
    data['vehicle_type'] = this.vehicleType;
    data['isTrackerInstalled'] = this.isTrackerInstalled;
    data['last_location_lat'] = this.lastLocationLat;
    data['last_location_long'] = this.lastLocationLong;
    data['last_location_time'] = this.lastLocationTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Check {
  int? id;
  int? checkNo;
  int? imRef;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  Solved? solved;

  Check(
      {this.id,
      this.checkNo,
      this.imRef,
      this.name,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.solved});

  Check.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkNo = json['check_no'];
    imRef = json['im_ref'];
    name = json['name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    solved =
        json['solved'] != null ? new Solved.fromJson(json['solved']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['check_no'] = this.checkNo;
    data['im_ref'] = this.imRef;
    data['name'] = this.name;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.solved != null) {
      data['solved'] = this.solved!.toJson();
    }
    return data;
  }
}

class Solved {
  int? id;
  int? employeeId;
  int? vehicleInspectionId;
  int? checkNo;
  Null? imRef;
  String? name;
  String? type;
  String? code;
  String? comment;
  String? status;
  String? createdAt;
  String? updatedAt;

  Solved(
      {this.id,
      this.employeeId,
      this.vehicleInspectionId,
      this.checkNo,
      this.imRef,
      this.name,
      this.type,
      this.code,
      this.comment,
      this.status,
      this.createdAt,
      this.updatedAt});

  Solved.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    vehicleInspectionId = json['vehicle_inspection_id'];
    checkNo = json['check_no'];
    imRef = json['im_ref'];
    name = json['name'];
    type = json['type'];
    code = json['code'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['vehicle_inspection_id'] = this.vehicleInspectionId;
    data['check_no'] = this.checkNo;
    data['im_ref'] = this.imRef;
    data['name'] = this.name;
    data['type'] = this.type;
    data['code'] = this.code;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CheckOptions {
  String? id;
  String? value;

  CheckOptions({this.id, this.value});

  CheckOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}

class Inspection {
  int? id;
  int? employeeId;
  int? vehicleId;
  String? type;
  String? date;
  String? odometerReading;
  String? vehicleType;
  String? status;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  Inspection(
      {this.id,
      this.employeeId,
      this.vehicleId,
      this.type,
      this.date,
      this.odometerReading,
      this.vehicleType,
      this.status,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  Inspection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    vehicleId = json['vehicle_id'];
    type = json['type'];
    date = json['date'];
    odometerReading = json['odometer_reading'];
    vehicleType = json['vehicle_type'];
    status = json['status'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['vehicle_id'] = this.vehicleId;
    data['type'] = this.type;
    data['date'] = this.date;
    data['odometer_reading'] = this.odometerReading;
    data['vehicle_type'] = this.vehicleType;
    data['status'] = this.status;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
