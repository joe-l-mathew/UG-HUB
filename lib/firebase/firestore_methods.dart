import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/home_screen.dart';
import 'package:ug_hub/screens/user_data_pages/select_university_screen.dart';

class Firestoremethods {
  final _firestore = FirebaseFirestore.instance;
  //Check for existing user
  Future<bool> doesUserExist(String uid) async {
    var res = await _firestore.collection(collectionUser).get();
    List docList = res.docs.map((e) => e.id).toList();
    return docList.contains(uid);
  }

  //check for username

  Future<bool> doesNameExist(String uid) async {
    var userDetails =
        await _firestore.collection(collectionUser).doc(uid).get();
    UserModel userModel = UserModel.fromSnap(userDetails);
    if (userModel.name == null) {
      return false;
    } else {
      return true;
    }
  }

  //check for university

  Future<bool> doesUniversityExist(String uid) async {
    var userDetails =
        await _firestore.collection(collectionUser).doc(uid).get();
    UserModel userModel = UserModel.fromSnap(userDetails);
    if (userModel.university == null) {
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
    UserModel? user =
        Provider.of<UserProvider>(context, listen: false).userModel;
    Provider.of<UserProvider>(context, listen: false)
        .setUserModel(userModelc: UserModel(uid: user!.uid, name: name));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => const SelectUniversityScreen()));
  }

  //add university to database
  addUniversityToFirestore(String univId, BuildContext context) async {
    await _firestore
        .collection(collectionUser)
        .doc(Provider.of<UserProvider>(context, listen: false).userModel!.uid)
        .update({collectionUniversity: univId});
    UserModel? user =
        Provider.of<UserProvider>(context, listen: false).userModel;
    Provider.of<UserProvider>(context, listen: false).setUserModel(
        userModelc:
            UserModel(uid: user!.uid, name: user.name, university: univId));
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => const HomeScreen()));
  }
}
