import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/model/branch_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/branch_provider.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/landing_page.dart';
import 'package:ug_hub/screens/user_data_pages/select_branch.dart';
import 'package:ug_hub/screens/user_data_pages/select_university_screen.dart';

class Firestoremethods {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  //Check for existing user
  Future<bool> doesUserExist(String uid) async {
    var res = await _firestore.collection(collectionUser).get();
    List docList = res.docs.map((e) => e.id).toList();
    return docList.contains(uid);
  }

//get user details from firestore
  Future<void> getUserDetail(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false).setUserModel(
      userModelc: UserModel.fromSnap(
        await _firestore
            .collection(collectionUser)
            .doc(_auth.currentUser!.uid)
            .get(),
      ),
    );
  }

  //check for username

  Future<bool> doesNameExist(String uid, BuildContext context) async {
    await getUserDetail(context);

    if (Provider.of<UserProvider>(context, listen: false).userModel!.name ==
        null) {
      return false;
    } else {
      return true;
    }
  }

  //check for university

  Future<bool> doesUniversityExist(String uid, BuildContext context) async {
    await getUserDetail(context);

    if (Provider.of<UserProvider>(context, listen: false)
            .userModel!
            .university ==
        null) {
      return false;
    } else {
      return true;
    }
  }

//check for branch
  Future<bool> doesBranchtExist(String uid, BuildContext context) async {
    await getUserDetail(context);
    if (Provider.of<UserProvider>(context, listen: false).userModel!.branch ==
        null) {
      return false;
    } else {
      return true;
    }
  }

  //add user to firestore
  addUserToFirestore(UserModel userModel) async {
    await _firestore
        .collection(collectionUser)
        .doc(userModel.uid)
        .set(userModel.toJson());
  }

  //add name to database
  addNameToFirestore(String name, BuildContext context) async {
    await _firestore
        .collection(collectionUser)
        .doc(Provider.of<UserProvider>(context, listen: false).userModel!.uid)
        .update({collectionUserName: name});
    await getUserDetail(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => const SelectUniversityScreen()));
  }

  //add universityName to database
  Future<void> addUniversityToFirestore(
      String univId, BuildContext context) async {
    await _firestore
        .collection(collectionUser)
        .doc(Provider.of<UserProvider>(context, listen: false).userModel!.uid)
        .update({
      collectionUniversity: univId,
      'branch': null,
      "universityName": Provider.of<UniversityProvider>(context, listen: false)
          .selectedUniversityName
    });
    await getUserDetail(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const SelectBranchScreen(),
      ),
    );
  }

  //add branch name to database
  Future<void> addBranchToFirestore(
      {required String branchId, required BuildContext context}) async {
    var path =
        _firestore.collection(collectionUser).doc(_auth.currentUser!.uid);
    await path.update({
      collectionUserBranch: branchId,
      'branchName': Provider.of<BranchProvider>(context, listen: false)
          .selectedBranchName,
    });

    getUserDetail(context);
    // await getBranchModel(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => const LandingPage()),
        (route) => false);
  }

  // addUniversityModel to database
  Future<void> addUniversityModel(
      String displayName, String fullName, String url) async {
    await _firestore
        .collection(collectionUniversity)
        .add({'Display name': displayName, 'name': fullName, 'logo uri': url});
  }

//add branch model
  Future<void> addBranchModel(
      BranchModel branchModel, BuildContext context) async {
    int numOfSem = int.parse(branchModel.numberOfSemester);
    await getUserDetail(context);
    var refrence = _firestore
        .collection(collectionUniversity)
        .doc(Provider.of<UserProvider>(context, listen: false)
            .userModel!
            .university)
        .collection(collectionBranch);
    var returnValue = await refrence.add(branchModel.toJson());
    for (int i = 0; i < numOfSem; i++) {
      await refrence
          .doc(returnValue.id)
          .collection(collectionSemester)
          .add({'name': "Semester " + (i + 1).toString()});
    }
  }

  Future<void> getBranchModel(BuildContext context) async {
    var snap = await _firestore
        .collection(collectionUniversity)
        .doc(Provider.of<UserProvider>(context, listen: false)
            .userModel!
            .university)
        .collection(collectionBranch)
        .doc(
            Provider.of<UserProvider>(context, listen: false).userModel!.branch)
        .get();
    Provider.of<BranchProvider>(context, listen: false)
        .setBranchModel(BranchModel.fromSnap(snap));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSemesterList(
      BuildContext context) async {
    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    return await _firestore
        .collection(collectionUniversity)
        .doc(_user.university)
        .collection(collectionBranch)
        .doc(_user.branch)
        .collection('Semester')
        .orderBy('name')
        .get();
    // print(firestoreGet.docs[1].data()['name']);
  }

  Future<void> addSemesterToUser(BuildContext context,
      {required String semesterId, required String semesterName}) async {
    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    await _firestore
        .collection(collectionUser)
        .doc(_user.uid)
        .update({"semester": semesterId, "semesterName": semesterName});
    getUserDetail(context);
  }
}
