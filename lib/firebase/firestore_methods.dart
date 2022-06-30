import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firebase_storage_methods.dart';
import 'package:ug_hub/model/branch_model.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/model/other_link_model.dart';
import 'package:ug_hub/model/subject_model.dart';
import 'package:ug_hub/model/upload_pdf_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/model/youtube_model.dart';
import 'package:ug_hub/provider/branch_provider.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/provider/upload_pdf_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/landing_page.dart';
import 'package:ug_hub/screens/user_data_pages/select_branch.dart';
import 'package:ug_hub/screens/user_data_pages/select_university_screen.dart';

import '../provider/upload_status_provider.dart';

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

  Future<void> addModule(
      BuildContext context, SubjectModel subjectModel) async {
    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    var path = _firestore
        .collection(collectionUniversity)
        .doc(_user.university)
        .collection(collectionBranch)
        .doc(_user.branch)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionSubject);
    var res = await path.add(subjectModel.toJson());
    for (int i = 0; i < int.parse(subjectModel.numberOfModule); i++) {
      await path
          .doc(res.id)
          .collection(collectionModule)
          .add({"name": "Module ${i + 1}"});
    }
  }

  Future<void> addPdftoDatabase(BuildContext context) async {
    ModuleModel? _moduleModel =
        Provider.of<ModuleModelProvider>(context, listen: false).getModuleModel;
    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    var path = _firestore
        .collection(collectionUniversity)
        .doc(_user.university)
        .collection(collectionBranch)
        .doc(_user.branch)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionSubject)
        .doc(_moduleModel!.subjectId)
        .collection(collectionModule)
        .doc(_moduleModel.moduleId);
    String downloadUrl = await FirebaseStorageMethods().addPdfToStorage(
        Provider.of<UploadPdfProvider>(context, listen: false).file!, context);

    UploadPdfModel uploadPdfModel = UploadPdfModel(
        userName:
            Provider.of<UserProvider>(context, listen: false).userModel!.name!,
        fileName: Provider.of<UploadPdfProvider>(context, listen: false)
            .inputFileName!,
        uid: Provider.of<UserProvider>(context, listen: false).userModel!.uid,
        fileUrl: downloadUrl,
        likes: []);
    await path
        .collection(collectionPdf)
        .add(uploadPdfModel.toJson(uploadPdfModel));
    Provider.of<UploadStatusProvider>(context, listen: false).setUploadStatus =
        null;
  }

  Future<void> addYoutubeLink(
      {required String channelName,
      required String youtubeLink,
      required BuildContext context}) async {
    ModuleModel? _moduleModel =
        Provider.of<ModuleModelProvider>(context, listen: false).getModuleModel;
    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    YoutubeModel ytModel = YoutubeModel(
        youtubeLink: youtubeLink,
        youtubeChannelName: channelName,
        likes: [],
        uid: _user.uid,
        userName: _user.name!);
    var path = _firestore
        .collection(collectionUniversity)
        .doc(_user.university)
        .collection(collectionBranch)
        .doc(_user.branch)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionSubject)
        .doc(_moduleModel!.subjectId)
        .collection(collectionModule)
        .doc(_moduleModel.moduleId);
    await path.collection(collectionYoutube).add(ytModel.toJson(ytModel));
  }

  Future<void> addOtherLink(
      {required String link,
      required String linkName,
      required BuildContext context}) async {
    ModuleModel? _moduleModel =
        Provider.of<ModuleModelProvider>(context, listen: false).getModuleModel;
    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    OtherLinkModel otherLinkModel = OtherLinkModel(
        uid: _user.uid,
        userName: _user.name!,
        link: link,
        linkName: linkName,
        likes: []);
    var path = _firestore
        .collection(collectionUniversity)
        .doc(_user.university)
        .collection(collectionBranch)
        .doc(_user.branch)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionSubject)
        .doc(_moduleModel!.subjectId)
        .collection(collectionModule)
        .doc(_moduleModel.moduleId);
    await path
        .collection(collectionOtherLink)
        .add(otherLinkModel.toJson(otherLinkModel));
  }

  // Future<void> addALike(
  //     {required DocumentReference<Map<String, dynamic>> path,
  //     required BuildContext context,
  //     required int index,
  //     required String collectionName,
  //     required String docId}) async {
  //   UserModel _user =
  //       Provider.of<UserProvider>(context, listen: false).userModel!;
  //   await path.collection(collectionName).doc(docId).update({
  //     'likes': FieldValue.arrayUnion([_user.uid])
  //   });
  // }

  Future<String> likePost(
      {required DocumentReference<Map<String, dynamic>> path,
      required String docId,
      required String uid,
      required List likes,
      required String collectionName}) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        await path.collection(collectionName).doc(docId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        print("unliked");
      } else {
        // else we need to add uid to the likes array
        await path.collection(collectionName).doc(docId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        print("liked");
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
