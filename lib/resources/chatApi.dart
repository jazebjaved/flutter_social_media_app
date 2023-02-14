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
        .snapshots();
  }

  Future<void> sendMessage(UserModel.User chatUser, String msg) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatUser.uid,
        msg: msg,
        read: "",
        type: Type.text,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chat/${getConversationID(chatUser.uid)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
