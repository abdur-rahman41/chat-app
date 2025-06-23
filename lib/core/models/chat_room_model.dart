import 'package:chat_app/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String roomId;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> userIds;
  final List<UserModel> users;

  ChatRoomModel({
    required this.roomId,
    required this.createdAt,
    required this.createdBy,
    required this.userIds,
    required this.users,
  });

  /// Convert ChatRoomModel to Map (for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'users': users.map((user) => user.toMap()).toList(),
    };
  }

  /// Create ChatRoomModel from Firestore document
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      createdBy: map['createdBy'] ?? '',
      userIds: List<String>.from(map['userIds'] ?? []),
      users: (map['users'] as List<dynamic>)
          .map((user) => UserModel.fromMap(user))
          .toList(),
    );
  }
}



