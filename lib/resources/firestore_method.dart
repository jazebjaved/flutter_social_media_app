import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/misc/utils.dart';
import 'package:first_app/models/notification_feed.dart';
import 'package:first_app/resources/storage_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../models/user.dart' as UserModel;

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> UploadPost({
    required String description,
    required String uid,
    required String profImage,
    required String username,
    required Uint8List file,
    required bool isVideo,
  }) async {
    String res = 'some error occure';
    try {
      if (description.isNotEmpty) {
        String postPicUrl =
            await StorageMethods().uploadImageToStorage('post', file, true);

        String postId = const Uuid().v1();
        Post post = Post(
            description: description,
            username: username,
            uid: uid,
            postId: postId,
            datePublished: DateTime.now(),
            postPicUrl: postPicUrl,
            photoUrl: profImage,
            likes: [],
            isVideo: isVideo);

        await _firestore.collection('post').doc(postId).set(post.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(Post post, String uid, List likes, UserModel.User user,
      String type) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(post.postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });

        var doc = await _firestore
            .collection('notifyFeeds')
            .doc(post.uid)
            .collection('feeds')
            .where('type', isEqualTo: 'like')
            .where('postId', isEqualTo: post.postId)
            .where('userId', isEqualTo: user.uid)
            .get();
        for (var element in doc.docs) {
          element.reference.delete();
          print('deleted ${element.reference.id}');
        }
      } else {
        await _firestore.collection('post').doc(post.postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        String notificationId = const Uuid().v1();

        final NotifyFeed notifyfeed = NotifyFeed(
          type: type,
          username: user.username,
          userId: user.uid,
          userProfileImg: user.photoUrl,
          postId: post.postId,
          postImg: post.postPicUrl,
          timestamp: DateTime.now(),
          read: '',
          followId: '',
          commentId: '',
          notificationId: notificationId,
        );
        if (_auth.currentUser!.uid != post.uid) {
          // await _firestore
          //     .collection('feed')
          //     .doc(post.uid)
          //     .collection('like')
          //     .doc(post.postId)
          //     .collection('likebyID')
          //     .doc(user.uid)
          //     .set(notifyfeed.toJson());

          await _firestore
              .collection('notifyFeeds')
              .doc(post.uid)
              .collection('feeds')
              .doc(notificationId)
              .set(notifyfeed.toJson());
        }
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> PostComment(
      Post post, UserModel.User user, String type, String text) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('post')
            .doc(post.postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'name': user.username,
          'commentId': commentId,
          'profPic': user.photoUrl,
          'uid': user.uid,
          'postId': post.postId,
          'text': text,
          'datePublished': DateTime.now(),
        });

        String notificationId = const Uuid().v1();

        final NotifyFeed notifyfeed = NotifyFeed(
          type: type,
          username: user.username,
          userId: user.uid,
          userProfileImg: user.photoUrl,
          postId: post.postId,
          postImg: post.postPicUrl,
          timestamp: DateTime.now(),
          read: '',
          followId: '',
          commentId: commentId,
          notificationId: notificationId,
        );
        if (_auth.currentUser!.uid != post.uid) {
          await _firestore
              .collection('notifyFeeds')
              .doc(post.uid)
              .collection('feeds')
              .doc(notificationId)
              .set(notifyfeed.toJson());
        }
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(
      String uid, String postId, BuildContext context) async {
    try {
      if (_auth.currentUser!.uid == uid) {
        await _firestore.collection('post').doc(postId).delete();
        ShowSnackBar('Post has been deleted', context);
      } else {
        ShowSnackBar('You are not allow to delete', context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteComment(String uid, String postId, String commentId,
      String postOwnerId, BuildContext context) async {
    try {
      if (_auth.currentUser!.uid == uid) {
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .delete();

        var doc = await _firestore
            .collection('notifyFeeds')
            .doc(postOwnerId)
            .collection('feeds')
            .where('type', isEqualTo: 'comment')
            .where('postId', isEqualTo: postId)
            .where('userId', isEqualTo: uid)
            .get();
        for (var element in doc.docs) {
          element.reference.delete();
          print('deleted ${element.reference.id}');
        }
        ShowSnackBar('Comment has been deleted', context);
      } else {
        ShowSnackBar('You are not allow to delete', context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(
    String followId,
    UserModel.User currentUser,
    type,
  ) async {
    try {
      DocumentSnapshot snap =
          // following means that i follow other people
          await _firestore.collection('user').doc(currentUser.uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([currentUser.uid])
        });
        await _firestore.collection('user').doc(currentUser.uid).update({
          'following': FieldValue.arrayRemove([followId])
        });

        var doc = await _firestore
            .collection('notifyFeeds')
            .doc(followId)
            .collection('feeds')
            .where('type', isEqualTo: 'follow')
            .where('userId', isEqualTo: currentUser.uid)
            .get();
        for (var element in doc.docs) {
          element.reference.delete();
          print('deleted ${element.reference.id}');
        }
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([currentUser.uid])
        });
        await _firestore.collection('user').doc(currentUser.uid).update({
          'following': FieldValue.arrayUnion([followId])
        });

        String notificationId = const Uuid().v1();

        final NotifyFeed notifyfeed = NotifyFeed(
          type: type,
          username: currentUser.username,
          userId: currentUser.uid,
          userProfileImg: currentUser.photoUrl,
          postId: '',
          postImg: '',
          timestamp: DateTime.now(),
          read: '',
          followId: currentUser.uid,
          commentId: '',
          notificationId: notificationId,
        );

        await _firestore
            .collection('notifyFeeds')
            .doc(followId)
            .collection('feeds')
            .doc(notificationId)
            .set(notifyfeed.toJson());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> currentUserPost(String uid) {
    return _firestore.collection('post').where('uid', isEqualTo: uid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> gettNotifyFeed() {
    return _firestore
        .collection('notifyFeeds')
        .doc(_auth.currentUser!.uid)
        .collection('feeds')
        .snapshots();
  }

  Future<void> updateNotifyReadStatus(NotifyFeed notifyFeed) async {
    try {
      var a = await _firestore
          .collection('notifyFeeds')
          .doc(_auth.currentUser!.uid)
          .collection('feeds')
          .doc(notifyFeed.notificationId)
          .get();

      if (a.exists) {
        return _firestore
            .collection('notifyFeeds')
            .doc(_auth.currentUser!.uid)
            .collection('feeds')
            .doc(notifyFeed.notificationId)
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      } else {
        return _firestore
            .collection('notifyFeeds')
            .doc(_auth.currentUser!.uid)
            .collection('feeds')
            .doc(notifyFeed.notificationId)
            .set({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUnreadNotificationAmount() {
    return _firestore
        .collection('notifyFeeds')
        .doc(_auth.currentUser!.uid)
        .collection('feeds')
        .where('read', isEqualTo: '')
        .get();
  }
}
