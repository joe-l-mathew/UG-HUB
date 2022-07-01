import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? name;
  final String? university;
  final String? branch;
  final String? semester;
  final String? college;
  final String? universityName;
  final String? branchName;
  final String? profileUrl;
  final String? semesterName;
  final bool? isAdmin;
  final DateTime? expireTime;
  final bool? isTeacher;

  UserModel({
    required this.uid,
    this.isTeacher,
    this.isAdmin,
    this.expireTime,
    this.name,
    this.university,
    this.branch,
    this.semester,
    this.college,
    this.universityName,
    this.branchName,
    this.profileUrl,
    this.semesterName,
  });

  Map<String, dynamic> toJson() => {
        "isTeacher": isTeacher,
        "uid": uid,
        "name": name,
        "university": university,
        "branch": branch,
        "semester": semester,
        "college": college,
        "universityName": universityName,
        "branchName": branchName,
        "profileUrl": profileUrl,
        "semesterName": semesterName,
        "isAdmin": isAdmin,
        "expireTime": expireTime
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        isTeacher: snapshot['isTeacher'],
        isAdmin: snapshot['isAdmin'],
        uid: snapshot['uid'],
        branch: snapshot['branch'],
        college: snapshot['college'],
        name: snapshot['name'],
        semester: snapshot['semester'],
        university: snapshot['university'],
        universityName: snapshot['universityName'],
        branchName: snapshot['branchName'],
        profileUrl: snapshot['profileUrl'],
        expireTime: snapshot['expireTime'].toDate(),
        semesterName: snapshot['semesterName']);
  }
}
