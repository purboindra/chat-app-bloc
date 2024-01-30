// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomEntity _$ChatRoomEntityFromJson(Map<String, dynamic> json) =>
    ChatRoomEntity(
      id: json['id'] as String?,
      lastMessageId: json['last_message_id'] as String?,
      senderId: json['sender_id'] as String?,
      createdAt: json['created_at'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$ChatRoomEntityToJson(ChatRoomEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'last_message_id': instance.lastMessageId,
      'sender_id': instance.senderId,
      'created_at': instance.createdAt,
      'username': instance.username,
      'email': instance.email,
      'token': instance.token,
      'avatar_url': instance.avatarUrl,
    };
