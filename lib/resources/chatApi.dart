import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/message.dart';
import '../models/user.dart' as UserModel;

class ChatApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;

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

  Future<void> sendMessage(
      UserModel.User chatUser, String msg, Type type) async {
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
    await ref.doc(time).set(message.toJson());
  }

  Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chat/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future getUnreadMessageAmount(
    UserModel.User chatUser,
  ) async {
    var query = await firestore
        .collection('chat/${getConversationID(chatUser.uid)}/messages/')
        .where('read', isEqualTo: '')
        .get();

    int Count = query.docs.length;
    return Count;
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
