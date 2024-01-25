import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserEntity {
  String? id;
  String? email;
  String? password;
  int? createdAt;
  @JsonKey(name: "phone")
  String? phoneNumber;
  @JsonKey(name: "username")
  String? userName;
  @JsonKey(name: "avatar_url")
  String? avatarUrl;
  @JsonKey(name: "updated_at")
  int? updatedAt;
  UserEntity({
    this.id,
    this.email,
    this.password,
    this.createdAt,
    this.phoneNumber,
    this.userName,
    this.avatarUrl,
    this.updatedAt,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
