import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/screens/display_material_screen.dart';
import 'package:ug_hub/widgets/module_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/firebase_fields.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../utils/color.dart';

class SubjectBanner extends StatelessWidget {
  const SubjectBanner(
      {Key? key,
      required this.snapshot,
      required this.indexofSubject,
      required this.subId})
      : super(key: key);
  final String subId;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int indexofSubject;

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
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      snapshot.data!.docs[indexofSubject].data()['fullname'] +
                          " (" +
                          snapshot.data!.docs[indexofSubject]
                              .data()['shortName'] +
                          ")",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () async {
                              //view sylabus here
                              await launchUrl(
                                  Uri.parse(
                                    snapshot.data!.docs[indexofSubject]
                                        .data()['syllabusLink'],
                                  ),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: const Text(
                              'View Syllabus',
                              style: TextStyle(color: primaryColor),
                            ),
                          )))
                ],
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
                  .collection(collectionModule)
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshotModule) {
                if (snapshotModule.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                        color: primaryColor, size: 50),
                  );
                }
                return SizedBox(
                  width: double.infinity,
                  height: 138,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true, // 1st add
                      itemCount: snapshotModule.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<ModuleModelProvider>(context,
                                        listen: false)
                                    .setModuleModel =
                                ModuleModel(
                                    moduleName: snapshotModule.data!.docs[index]
                                        .data()['name'],
                                    moduleId:
                                        snapshotModule.data!.docs[index].id,
                                    subjectName: snapshot
                                        .data!.docs[indexofSubject]
                                        .data()['fullname'],
                                    subjectId:
                                        snapshot.data!.docs[indexofSubject].id,
                                    subjectShortName: snapshot
                                        .data!.docs[indexofSubject]
                                        .data()['shortName']);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        DisplayMaterialsScreen()));
                          },
                          child: ModuleListTile(
                              snapshotModule.data!.docs[index].data()['name'],
                              "No of module : 5"),
                        );
                        // return Text(Index.toString());
                      }),
                );
              }),
        ],
      ),
    );
  }
}
