import 'dart:developer';

import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:get/get.dart';

class ChatItem {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  ChatItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
  });
}

class ChatListViewModel extends GetxController {
  final db = DatabaseService();
  final currentUser = UserModel();
  RxList<UserModel> users = <UserModel>[].obs;

  List<UserModel> filteredUsers = <UserModel>[].obs;
  final userID = PreferenceManager.readData(key: 'user-id');
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("user id:${userID}");
    fetchUsers();
  }


  var chatItems = <ChatItem>[
    ChatItem(
      name: "Alice",
      message: "Hey, how are you?",
      time: "10:30 AM",
      avatarUrl: "https://i.pravatar.cc/150?img=1",
    ),
    ChatItem(
      name: "Bob",
      message: "Let's catch up later.",
      time: "09:45 AM",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    ChatItem(
      name: "Charlie",
      message: "I'll send the files soon.",
      time: "Yesterday",
      avatarUrl: "https://i.pravatar.cc/150?img=3",
    ),
  ].obs;


  fetchUsers() async {
    try {

      // final res = await _db.fetchUsers(_currentUser.uid!);

      db.fetchUserStream(userID).listen((data) {
        users.value = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
        print(" Data information");
        print(data);
        print(users);
        filteredUsers = users;

      });

      // if (res != null) {
      //   _users = res.map((e) => UserModel.fromMap(e)).toList();
      //   _filteredUsers = _users;
      //   notifyListeners();
      // }

    } catch (e) {

      log("Error Fetching Users: $e");
    }
  }
}
