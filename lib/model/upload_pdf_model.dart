import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPdfModel {
  final String fileName;
  final String uid;
  final List likes;
  final String fileUrl;

  UploadPdfModel(
      {required this.fileName,
      required this.uid,
      required this.fileUrl,
      required this.likes});

  Map<String, dynamic> toJson(UploadPdfModel pdfModel) {
    return {
      "fileName": fileName,
      "uid": uid,
      "likes": likes,
      "fileUrl": fileUrl
    };
  }

  static UploadPdfModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UploadPdfModel(
      likes: snapshot['likes'],
      fileName: snapshot['fileName'],
      uid: snapshot['uid'],
      fileUrl: snapshot['fileUrl'],
    );
  }
}
