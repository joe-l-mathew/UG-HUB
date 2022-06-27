import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/widgets/module_list_tile.dart';

import '../constants/firebase_fields.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../utils/color.dart';

class SubjectBanner extends StatelessWidget {
  const SubjectBanner(
      {Key? key,
      required this.snapshot,
      required this.index,
      required this.subId})
      : super(key: key);
  final String subId;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserProvider>(context).userModel;
    return SizedBox(
      height: 170,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                snapshot.data!.docs[index].data()['fullname'] +
                    " (" +
                    snapshot.data!.docs[index].data()['shortName'] +
                    ")",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(collectionUniversity)
                  .doc(_userModel!.university)
                  .collection(collectionBranch)
                  .doc(_userModel.branch)
                  .collection(collectionSemester)
                  .doc(_userModel.semester)
                  .collection(collectionSubject)
                  .doc(subId)
                  .collection('Module')
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                        color: primaryColor, size: 50),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true, // 1st add
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return ModuleListTile(
                            snapshot.data!.docs[index].data()['name'],
                            "No of module : 5");
                        // return Text(Index.toString());
                      }),
                );
              }),
        ],
      ),
    );
  }
}
