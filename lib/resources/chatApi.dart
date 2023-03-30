import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/models/message.dart';
import 'package:http/http.dart';
import '../models/user.dart' as UserModel;
import '../screen/chat_screen.dart';

class ChatApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  FirebaseMessaging fmessaging = FirebaseMessaging.instance;
  // for storing self information
  UserModel.User? me;

  Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();

    await fmessaging.getToken().then((t) {
      if (t != null) {
        me?.pushToken = t;
        log('Push Token: $t ');

        firestore.collection('user').doc(user.uid).update({'pushToken': t});
        log('Push Token: ${me?.pushToken} ');
      }
    });

    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.User.fromSnap(user);
        log('Push Token: ${me!.pushToken!}');
      }
    });
  }

  Future<void> sendPushNotification(
      UserModel.User chatUser, String msg, UserModel.User currentUser) async {
    try {
      var body = {
        "to": chatUser.pushToken,
        "notification": {
          "body": msg,
          "title": currentUser.username,
          "android_channel_id": "social_app",
        },

        //try but didnot work, it was route to specific screen
        // "data": {
        //   "doc_id": chatUser.uid,
        //   "to_uid": currentUser.uid,
        //   "to_avatar": currentUser.photoUrl,
        //   "to_name": currentUser.username,
        //   "click_action": currentUser.uid,
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAL7uvXBY:APA91bHJirP6YALjksS1XUle3LBgKz2JveF7Cx9mK4MnVztlR5Twiiz9_IyAbHQBW7AO-_H5Rw_9boFvre6nxErU1o1_9Hy36hbi0TQDqCBjSCkOu_EA8LcKgb_cwsher4k8sKQvPP5m'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

// for getting current user info
  Future<void> getSelfInfo() async {
    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.User.fromSnap(user);
        await getFirebaseMessagingToken();
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('user')
        .where('uid', isNotEqualTo: user.uid)
        .snapshots();
  }

  String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel.User user) {
    return firestore
        .collection('chat/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(UserModel.User chatUser, String msg, Type type,
      UserModel.User currentUser) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatUser.uid,
        msg: msg,
        read: "",
        type: type,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chat/${getConversationID(chatUser.uid)}/messages/');
    await ref
        .doc(time)
        .set(message.toJson())
        .then((value) => sendPushNotification(
              chatUser,
              type == Type.text ? msg : 'image',
              currentUser,
            ));
    ;
  }

  Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chat/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMessageAmount(
    UserModel.User chatUser,
  ) {
    return firestore
        .collection('chat/${getConversationID(chatUser.uid)}/messages/')
        .where('read', isEqualTo: '')
        .snapshots();

    // int Count = query.docs.length;
    // return Count;
  }

  //get only last message of a specific chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel.User user) {
    return firestore
        .collection('chat/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> updateFollowers(user) {
    return firestore.collection('user').doc(user).snapshots();
  }
}
