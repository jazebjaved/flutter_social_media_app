import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late final String username;
  late final String uid;
  late final String email;
  late final String bio;
  late final List followers;
  late final List following;
  late final String photoUrl;
  late final dob;
  late final String hobby;
  late final String study;
  late final String? pushToken;
  User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.dob,
    required this.hobby,
    required this.study,
    required this.pushToken,
  });

  Map<String, dynamic> toKson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': [],
        'following': [],
        'photoUrl': photoUrl,
        'dob': dob,
        'hobby': hobby,
        'study': study,
        'pushToken': pushToken,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      dob: snapshot['dob'],
      hobby: snapshot['hobby'],
      study: snapshot['study'],
      pushToken: snapshot['pushToken'],
    );
  }
}
