// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    MessageEntity(
      id: json['id'] as String?,
      chatRoomId: json['chat_room_id'] as String?,
      senderUserId: json['sender_user_id'] as String?,
      receiverUserId: json['receiver_user_id'] as String?,
      message: json['content'] as String?,
      attachmentId: json['attachment_id'] as String?,
      createdAt: json['created_at'] as int?,
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_room_id': instance.chatRoomId,
      'sender_user_id': instance.senderUserId,
      'receiver_user_id': instance.receiverUserId,
      'content': instance.message,
      'attachment_id': instance.attachmentId,
      'created_at': instance.createdAt,
    };
