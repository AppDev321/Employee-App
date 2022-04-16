import 'package:json_annotation/json_annotation.dart';
part 'user_entity.g.dart';

//done this file

@JsonSerializable()
class UserEntity {
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  UserEntity({this.firstName, this.lastName, this.dateOfBirth});
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
