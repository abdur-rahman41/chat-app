import 'package:chat_app/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String roomId;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> userIds;
  final List<UserModel> users;
  final LastMessage? lastMessage;
  final String roomType;
  final String? roomName;
  final Timestamp updateAt;


  ChatRoomModel(   {
    required this.roomId,
    required this.createdAt,
    required this.createdBy,
    required this.userIds,
    required this.users,
    this.lastMessage,
    required this.roomType,
    this.roomName,
    required this.updateAt,
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
      lastMessage: map['lastMessage'] is Map<String, dynamic>
          ? LastMessage.fromJson(map['lastMessage'])
          : null,
      roomType: map['roomType']??'',
      roomName: map['roomName']??'',
      updateAt: map['updateAt']??''

    );
  }
}

//Last message of room
class LastMessage {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final int timestamp;

  LastMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,

    };
  }
}


