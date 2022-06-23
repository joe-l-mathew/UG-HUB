import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? name;
  final String? university;
  final String? branch;
  final String? semester;
  final String? college;

  UserModel(
      {required this.uid,
      this.name,
      this.university,
      this.branch,
      this.semester,
      this.college});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "university": university,
        "branch": branch,
        "semester": semester,
        "college": college
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        uid: snapshot['uid'],
        branch: snapshot['branch'],
        college: snapshot['college'],
        name: snapshot['name'],
        semester: snapshot['semester'],
        university: snapshot['university']);
  }
}
