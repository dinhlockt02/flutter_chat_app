import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String id;
  final String email;
  final String displayName;
  final String photoUrl;
  final String aboutMe;

  const ChatUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.aboutMe,
  });

  ChatUser copyWith(
          {String? id,
          String? email,
          String? displayName,
          String? photoUrl,
          String? aboutMe}) =>
      ChatUser(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl ?? this.photoUrl,
        aboutMe: aboutMe ?? this.aboutMe,
      );

  ChatUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)
      : id = snapshot.id,
        email = snapshot.data()?["email"],
        displayName = snapshot.data()?["displayName"],
        photoUrl = snapshot.data()?["photoUrl"],
        aboutMe = snapshot.data()?["aboutMe"];

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (displayName != null) "displayName": displayName,
      if (photoUrl != null) "photoUrl": photoUrl,
      if (aboutMe != null) "aboutMe": aboutMe,
    };
  }
}
