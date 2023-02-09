import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String uid;
  final String postId;
  final datePublished;
  final String postPicUrl;
  final String photoUrl;
  final likes;
  Post({
    required this.description,
    required this.username,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postPicUrl,
    required this.photoUrl,
    required this.likes,
  });

  Map<String, dynamic> toKson() => {
        'description': description,
        'username': username,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'postPicUrl': postPicUrl,
        'photoUrl': photoUrl,
        'likes': likes,
      };
}
