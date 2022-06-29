import 'package:cloud_firestore/cloud_firestore.dart';

class OtherLinkModel {
  final String uid;
  final String userName;
  final String link;
  final String linkName;
  final List likes;

  OtherLinkModel(
      {required this.uid,
      required this.userName,
      required this.link,
      required this.linkName,
      required this.likes});

  Map<String, dynamic> toJson(OtherLinkModel otherLinkModel) {
    return {
      "uid": uid,
      "userName": userName,
      "link": link,
      "linkName": linkName,
      "likes": likes
    };
  }

  OtherLinkModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return OtherLinkModel(
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        link: snapshot['link'],
        linkName: snapshot['linkName'],
        likes: snapshot['likes']);
  }
}
