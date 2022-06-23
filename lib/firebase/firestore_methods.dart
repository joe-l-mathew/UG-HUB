import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/model/user_model.dart';

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
      print("No name Exist");
    } else {
      print("Name Exist");
    }
    return false;
  }

  //add user to firestore
  addUserToFirestore(UserModel userModel) async {
    await _firestore
        .collection(collectionUser)
        .doc(userModel.uid)
        .set(userModel.toJson());
  }
}
