import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chat;
  final String username;
  final String uid;
  final DateTime dateTime;
  final String? profileUrl;

  ChatModel(
      {required this.chat,
      required this.username,
      required this.uid,
      required this.dateTime,
      required this.profileUrl});

  Map<String, dynamic> toJson() {
    return {
      'chat': chat,
      'username': username,
      'uid': uid,
      'dateTime': dateTime,
      'profileUrl': profileUrl
    };
  }

  static ChatModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ChatModel(
        chat: snapshot['chat'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        dateTime: snapshot['dateTime'].toDate(),
        profileUrl: snapshot['profileUrl']);
  }
}
