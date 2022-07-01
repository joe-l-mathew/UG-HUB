import 'package:cloud_firestore/cloud_firestore.dart';

class ChatReplayModel {
  final String chatId;
  final String chat;
  final String username;
  final String uid;
  final DateTime dateTime;
  final String? profileUrl;

  ChatReplayModel(
      {required this.chat,
      required this.username,
      required this.uid,
      required this.dateTime,
      required this.chatId,
      required this.profileUrl});

  Map<String, dynamic> toJson() {
    return {
      'chat': chat,
      'chatId': chatId,
      'username': username,
      'uid': uid,
      'dateTime': dateTime,
      'profileUrl': profileUrl
    };
  }

  static ChatReplayModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ChatReplayModel(
        chatId: snapshot['chatId'],
        chat: snapshot['chat'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        dateTime: snapshot['dateTime'].toDate(),
        profileUrl: snapshot['profileUrl']);
  }
}
