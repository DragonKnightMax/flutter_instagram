import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String photoUrl;
  String uid;
  String username;
  String bio;
  List<dynamic> followers;
  List<dynamic> following;

  User({
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'photoUrl': photoUrl,
    'uid': uid,
    'username': username,
    'bio': bio,
    'followers': followers,
    'following': following,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}