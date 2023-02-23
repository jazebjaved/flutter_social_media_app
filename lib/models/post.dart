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

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'postPicUrl': postPicUrl,
        'photoUrl': photoUrl,
        'likes': likes,
      };

  static Post fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postPicUrl: snapshot['postPicUrl'],
      photoUrl: snapshot['photoUrl'],
      likes: snapshot['likes'],
    );
  }
}
