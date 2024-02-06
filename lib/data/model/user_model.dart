import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  String email;
  String name;
  String profileUrl;
  // String token;
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.profileUrl,
    // required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileUrl': profileUrl,
      // 'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      profileUrl: map['profileUrl'],
      // token: map['token'],
    );
  }

  static UserModel generateUserModelFromFirebaseUser({required User user}) {
    return UserModel(
      uid: user.uid,
      email: user.email!,
      name: user.displayName ?? user.email!.split('@').first,
      profileUrl: user.photoURL ?? '',
    );
  }
}
