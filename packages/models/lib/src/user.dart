import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class User extends Equatable {
  final String id;
  final String userName;
  final String phone;
  final String email;
  final String avatarUrl;
  final String status;

  const User({
    required this.id,
    required this.userName,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.status,
  });

  User copyWith({
    String? id,
    String? userName,
    String? phone,
    String? email,
    String? avatarUrl,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'phone': phone,
      'email': email,
      'avatarUrl': avatarUrl,
      'status': status,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? const Uuid().v4(),
      userName: map['userName'] ?? "",
      phone: map['phone'] ?? "",
      email: map['email'] ?? "",
      avatarUrl: map['avatarUrl'] ?? "",
      status: map['status'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [
        id,
        userName,
        phone,
        email,
        avatarUrl,
        status,
      ];
}
