import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String shortName;
  final String fullname;
  final String numberOfModule;

  SubjectModel(
      {required this.shortName,
      required this.fullname,
      required this.numberOfModule});

  Map<String, dynamic> toJson() {
    return {
      'shortName': shortName,
      'fullname': fullname,
      'numberOfModule': numberOfModule
    };
  }

  SubjectModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SubjectModel(
        shortName: snapshot["shortName"],
        fullname: snapshot["fullname"],
        numberOfModule: snapshot["numberOfModule"]);
  }
}
