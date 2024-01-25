import 'package:json_annotation/json_annotation.dart';

part 'chat_room_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatRoomEntity {
  String? id;
  String? lastMessageId;
  String? userId;
  int? createdAt;
  ChatRoomEntity({
    this.id,
    this.lastMessageId,
    this.userId,
    this.createdAt,
  });

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomEntityFromJson(json);
}
