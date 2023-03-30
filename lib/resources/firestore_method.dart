import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/misc/utils.dart';
import 'package:first_app/models/notification_feed.dart';
import 'package:first_app/resources/storage_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../models/user.dart' as UserModel;

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> UploadPost(
      {required String description,
      required String uid,
      required String profImage,
      required String username,
      required Uint8List file}) async {
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
        );

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

        await _firestore
            .collection('feed')
            .doc(post.uid)
            .collection('like')
            .doc(post.postId)
            .collection('likebyID')
            .doc(user.uid)
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      } else {
        await _firestore.collection('post').doc(post.postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });

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
        );
        if (_auth.currentUser!.uid != post.uid) {
          await _firestore
              .collection('feed')
              .doc(post.uid)
              .collection('like')
              .doc(post.postId)
              .collection('likebyID')
              .doc(user.uid)
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
        );
        if (_auth.currentUser!.uid != post.uid) {
          await _firestore
              .collection('feed')
              .doc(post.uid)
              .collection('comment')
              .doc(post.postId)
              .collection('commentbyID')
              .doc(commentId)
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
        ShowSnackBar('Many congragulation pot deleted', context);
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

        await _firestore
            .collection('feed')
            .doc(postOwnerId)
            .collection('comment')
            .doc(postId)
            .collection('commentbyID')
            .doc(commentId)
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
        ShowSnackBar('Many congragulation pot deleted', context);
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

        await _firestore
            .collection('feed')
            .doc(followId)
            .collection('follow')
            .doc(currentUser.uid)
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([currentUser.uid])
        });
        await _firestore.collection('user').doc(currentUser.uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
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
        );

        await _firestore
            .collection('feed')
            .doc(followId)
            .collection('follow')
            .doc(currentUser.uid)
            .set(notifyfeed.toJson());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> currentUserPost(String uid) {
    return _firestore.collection('post').where('uid', isEqualTo: uid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLikeNotifyFeed(String postId) {
    return _firestore
        .collection('feed')
        .doc(_auth.currentUser!.uid)
        .collection('like')
        .doc(postId)
        .collection('likebyID')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentNotifyFeed(
      String postId) {
    return _firestore
        .collection('feed')
        .doc(_auth.currentUser!.uid)
        .collection('comment')
        .doc(postId)
        .collection('commentbyID')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowNotifyFeed() {
    return _firestore
        .collection('feed')
        .doc(_auth.currentUser!.uid)
        .collection('follow')
        .snapshots();
  }

  Future<void> updateFollowReadStatus(NotifyFeed notifyFeed) async {
    try {
      var a = await _firestore
          .collection('feed')
          .doc(_auth.currentUser!.uid)
          .collection('follow')
          .doc(notifyFeed.followId)
          .get();

      if (a.exists) {
        return _firestore
            .collection('feed')
            .doc(_auth.currentUser!.uid)
            .collection('follow')
            .doc(notifyFeed.followId)
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      } else {
        return _firestore
            .collection('feed')
            .doc(_auth.currentUser!.uid)
            .collection('follow')
            .doc(notifyFeed.followId)
            .set({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateLikeReadStatus(NotifyFeed notifyFeed) async {
    try {
      var a = await _firestore
          .collection('feed')
          .doc(_auth.currentUser!.uid)
          .collection('like')
          .doc(notifyFeed.postId)
          .collection('likebyID')
          .doc(notifyFeed.userId)
          .get();

      if (a.exists) {
        return _firestore
            .collection('feed')
            .doc(_auth.currentUser!.uid)
            .collection('like')
            .doc(notifyFeed.postId)
            .collection('likebyID')
            .doc(notifyFeed.userId)
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      } else {
        return _firestore
            .collection('feed')
            .doc(_auth.currentUser!.uid)
            .collection('like')
            .doc(notifyFeed.postId)
            .collection('likebyID')
            .doc(notifyFeed.userId)
            .set({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateCommentReadStatus(NotifyFeed notifyFeed) async {
    try {
      var a = await _firestore
          .collection('feed')
          .doc(_auth.currentUser!.uid)
          .collection('comment')
          .doc(notifyFeed.postId)
          .collection('commentbyID')
          .doc(notifyFeed.commentId)
          .get();

      if (a.exists) {
        return _firestore
            .collection('feed')
            .doc(_auth.currentUser!.uid)
            .collection('comment')
            .doc(notifyFeed.postId)
            .collection('commentbyID')
            .doc(notifyFeed.commentId)
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      } else {
        return _firestore
            .collection('feed')
            .doc(_auth.currentUser!.uid)
            .collection('comment')
            .doc(notifyFeed.postId)
            .collection('commentbyID')
            .doc(notifyFeed.commentId)
            .set({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      }
    } catch (e) {
      print(e.toString());
    }
  }

// Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadNotificationAmount(
//     UserModel.User chatUser,
//   ) {
//     return firestore
//         .collection('chat/${getConversationID(chatUser.uid)}/messages/')
//         .where('read', isEqualTo: '')
//         .snapshots();

//     // int Count = query.docs.length;
//     // return Count;
//   }
}
