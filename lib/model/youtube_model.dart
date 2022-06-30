import 'package:cloud_firestore/cloud_firestore.dart';

class YoutubeModel {
  final String youtubeLink;
  final String youtubeChannelName;
  final String userName;
  final String uid;
  final List likes;

  YoutubeModel(
      {required this.userName,
      required this.likes, 
      required this.uid,
      required this.youtubeLink,
      required this.youtubeChannelName});

  Map<String, dynamic> toJson(YoutubeModel youtubeModel) {
    return {
      "youtubeLink": youtubeLink,
      "youtubeChannelName": youtubeChannelName,
      "userName":userName,
      "likes":likes,
      "uid":uid
    };
  }

  static YoutubeModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return YoutubeModel(
      likes: snapshot["like"],
      uid: snapshot['uid'],
      userName: snapshot['userName'],
        youtubeLink: snapshot['youtubeLink'],
        youtubeChannelName: snapshot['youtubeChannelName']);
  }
}
