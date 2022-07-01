import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String shortName;
  final String fullname;
  final String numberOfModule;
  final String syllabusLink;

  SubjectModel(
      {required this.shortName,
      required this.syllabusLink,
      required this.fullname,
      required this.numberOfModule});

  Map<String, dynamic> toJson() {
    return {
      'shortName': shortName,
      'fullname': fullname,
      'numberOfModule': numberOfModule,
      'syllabusLink': syllabusLink
    };
  }

  SubjectModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SubjectModel(
        syllabusLink: snapshot['syllabusLink'],
        shortName: snapshot["shortName"],
        fullname: snapshot["fullname"],
        numberOfModule: snapshot["numberOfModule"]);
  }
}
