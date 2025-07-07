import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? imageUrl;
     Map<String, dynamic>? lastMessage;
  final int? unreadCounter;
  final String? deviceToken;
  final Timestamp? updateTime;

  UserModel(
      {this.uid,
        this.name,
        this.email,
        this.imageUrl,
        this.lastMessage,
        this.unreadCounter,
        this.deviceToken,
        this.updateTime
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage,
      'unreadCounter': unreadCounter,
      'updateTime':updateTime
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      lastMessage: map['lastMessage'] != null
          ? Map<String, dynamic>.from(
          map['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCounter:
      map['unreadCounter'] != null ? map['unreadCounter'] as int : null,
      deviceToken: map['deviceToken'] !=null ? map['deviceToken'] as String : null,
      updateTime: map['updateTime'] !=null ? map['updateTime'] as Timestamp : null
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, imageUrl: $imageUrl, lastMessage: $lastMessage, unreadCounter: $unreadCounter,updateTime:$updateTime)';
  }
}