import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String name;
  String profilePic;
  String email;
  String uid;

  User({
    required this.name,
    required this.profilePic,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePic": profilePic,
        "email": email,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
      name: snap['name'],
      profilePic: snap['profilePic'],
      email: snap['email'],
      uid: snap['uid'],
    );
  }
}
