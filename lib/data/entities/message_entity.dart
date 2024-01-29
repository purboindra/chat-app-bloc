import 'package:json_annotation/json_annotation.dart';

part 'message_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageEntity {
  String? id;
  @JsonKey(name: "chat_room_id")
  String? chatRoomId;
  @JsonKey(name: "sender_user_id")
  String? senderUserId;
  @JsonKey(name: "receiver_user_id")
  String? receiverUserId;
  @JsonKey(name: "content")
  String? message;
  @JsonKey(name: "attachment_id")
  String? attachmentId;
  @JsonKey(name: "created_at")
  String? createdAt;
  MessageEntity({
    this.id,
    this.chatRoomId,
    this.senderUserId,
    this.receiverUserId,
    this.message,
    this.attachmentId,
    this.createdAt,
  });

  // final String? id;
  // final String chatRoomId;
  // final String senderUserId;
  // final String receiverUserId;
  // final String? content;
  // final Attachment? attachment;
  // final DateTime createdAt;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}
