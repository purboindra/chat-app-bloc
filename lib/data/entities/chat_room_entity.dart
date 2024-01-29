import 'package:json_annotation/json_annotation.dart';

part 'chat_room_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatRoomEntity {
  String? id;
  String? lastMessageId;
  String? userId;
  String? createdAt;
  String? username;
  String? email;
  String? token;
  String? avatarUrl;
  ChatRoomEntity({
    this.id,
    this.lastMessageId,
    this.userId,
    this.createdAt,
    this.avatarUrl,
    this.email,
    this.token,
    this.username,
  });

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomEntityToJson(this);
}
