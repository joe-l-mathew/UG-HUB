import 'package:cloud_firestore/cloud_firestore.dart';

class YoutubeModel {
  final String youtubeLink;
  final String youtubeChannelName;
  final String userName;
  final String uid;
  final List like;

  YoutubeModel(
      {required this.userName,
      required this.like, 
      required this.uid,
      required this.youtubeLink,
      required this.youtubeChannelName});

  Map<String, dynamic> toJson(YoutubeModel youtubeModel) {
    return {
      "youtubeLink": youtubeLink,
      "youtubeChannelName": youtubeChannelName,
      "userName":userName,
      "like":like,
      "uid":uid
    };
  }

  static YoutubeModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return YoutubeModel(
      like: snapshot["like"],
      uid: snapshot['uid'],
      userName: snapshot['userName'],
        youtubeLink: snapshot['youtubeLink'],
        youtubeChannelName: snapshot['youtubeChannelName']);
  }
}
