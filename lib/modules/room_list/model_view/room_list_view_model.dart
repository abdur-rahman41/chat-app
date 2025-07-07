import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/chat_services.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'dart:convert';


class RoomListViewModel extends GetxController {
  final ChatService _chatService = ChatService();
  final DatabaseService db = DatabaseService();
  final currentReceiver = UserModel();
  RxList<UserModel> users = <UserModel>[].obs;
  RxList<Message> messages = <Message>[].obs;
  RxList<String> lastMessages = <String>[].obs;
  final userID = PreferenceManager.readData(key: 'user-id');

  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Timer? _timer;
  int _counter = 0;
  RxBool isLoading = false.obs;



  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
    fetchUsers();
    setupFCM();
    getTimeUpdate();





  }
  Future<void> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;


    try {
      String? token = await messaging.getToken();
      print("✅ Device Token: $token");
      PreferenceManager.writeData(key: PrefKey.DEVICE_UNIQUE, value:token );

    } catch (e) {
      print("❌ Error getting device token: $e");
    }
  }

  Future<void> fetchChatRooms() async {
    var userID = PreferenceManager.readData(key: 'user-id');
    await db.updateDeviceToken(PrefKey.userID,PrefKey.DEVICE_UNIQUE);


    _chatService.getChatRoomSnapshots(userID).listen((snapshot) {
      print('snapshot data: ${snapshot.docs}');
      chatRooms.value = snapshot.docs
          .map((doc) => ChatRoomModel.fromMap(doc.data()))
          .toList();

      chatRooms.sort((a, b) => b.updateAt.compareTo(a.updateAt));

    }, onError: (e) {
      print(" Error fetching chat rooms: $e");
    });


    fetchLastMessges();


  }

  fetchLastMessges() async {
    print("Last msg");

    var loggedInUserID = PreferenceManager.readData(key: 'user-id');

    try {
        print("Chat room length ${chatRooms.length}");
      for (int i = 0; i < chatRooms.length; i++) {

        final room = chatRooms[i];
        print("index ${room.userIds}");

        _chatService.getLastMessage(room.roomId).listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first;
            print("Document${doc.data()}");
            final message = Message.fromMap(doc.data());



          } else {
            print("No message found for chat room: ${room.roomId}");
          }
        });
      }

    } catch (e) {
      log("Error fetching last messages: $e");
    }
  }

  fetchUsers() async {
    try {
      db.fetchUserStream(userID).listen((data) {
        users.value = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
      });

    } catch (e) {

      log("Error Fetching Users: $e");
    }
  }

 Future<ChatRoomModel?> createRoom(String receiverID,String name, String image) async {
    isLoading.value=true;
    print(" ✅ Circular Loading ${isLoading}");

    print(receiverID);

    try {

      final now = DateTime.now();


      String chatRoomID ="${userID}_${receiverID}";
      final client =  await db.loadUser(userID);
      final user= UserModel.fromMap(client as Map<String, dynamic>);
      print("user:${user}");



      final user1 = UserModel(
        name: user.name!,
        uid: userID,
        imageUrl: user.imageUrl,

      );
      final user2 = UserModel(
        name: name,
        uid : receiverID,
        imageUrl: image,

      );
      var partner = UserModel(name:name,uid: receiverID);
      List<String>userIds=[userID,receiverID];


       var result = await _chatService.createRoom([user1,user2],userIds,'Single','');


      if(result.docs.isNotEmpty) {
        var responseData = ChatRoomModel.fromMap(result.docs.first.data());
        isLoading.value=false;
        return responseData;

      } else {
        isLoading.value=false;
        return null;
      }



    } catch (e) {
      rethrow;
    }
  }


  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcmToken = '';


    // Ask for permission (iOS only)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');

      // Get FCM token
      fcmToken = await messaging.getToken();
      print('🔑 FCM Token: $fcmToken');

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📬 Foreground: ${message.notification?.title}');
      });

      // When user taps on notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('➡️ Opened from background: ${message.notification?.title}');
      });
    } else {
      print('❌ Notification permission denied');
    }
  }

getTimeUpdate()
{
  var userID = PreferenceManager.readData(key: 'user-id');
  _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    // print("⏰ Update at ${DateTime.now()} - counter: $_counter");


    db.updateTime(userID,Timestamp.now() );

  });

  // print("Activeness : ${_timer!.isActive}");

}


}
