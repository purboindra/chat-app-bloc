// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      createdAt: json['created_at'] as String?,
      phoneNumber: json['phone'] as String?,
      userName: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      updatedAt: json['updated_at'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'created_at': instance.createdAt,
      'token': instance.token,
      'phone': instance.phoneNumber,
      'username': instance.userName,
      'avatar_url': instance.avatarUrl,
      'updated_at': instance.updatedAt,
    };
