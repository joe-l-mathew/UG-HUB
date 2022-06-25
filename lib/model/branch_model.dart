import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final String displayName;
  final String name;
  final String logoUrl;
  final String numberOfSemester;

  BranchModel(
      {required this.displayName,
      required this.name,
      required this.logoUrl,
      required this.numberOfSemester});

  Map<String, dynamic> toJson() {
    return {
      'Display name': displayName,
      'name': name,
      'logo uri': logoUrl,
      'number of semester': numberOfSemester,
    };
  }

  static BranchModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return BranchModel(
        displayName: snapshot['Display name'],
        name: snapshot['name'],
        logoUrl: snapshot['logo uri'],
        numberOfSemester: snapshot['number of semester']);
  }
}
