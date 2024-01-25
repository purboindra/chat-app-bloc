// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomEntity _$ChatRoomEntityFromJson(Map<String, dynamic> json) =>
    ChatRoomEntity(
      id: json['id'] as String?,
      lastMessageId: json['last_message_id'] as String?,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] as int?,
    );

Map<String, dynamic> _$ChatRoomEntityToJson(ChatRoomEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'last_message_id': instance.lastMessageId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
    };
