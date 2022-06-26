import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String shortName;
  final String fullname;
  final String numberOfSemester;

  SubjectModel(
      {required this.shortName,
      required this.fullname,
      required this.numberOfSemester});

  Map<String, dynamic> toJson() {
    return {
      'shortName': shortName,
      'fullname': fullname,
      'numberOfSemester': numberOfSemester
    };
  }

  SubjectModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SubjectModel(
        shortName: snapshot["shortName"],
        fullname: snapshot["fullname"],
        numberOfSemester: snapshot["numberOfSemester"]);
  }
}
