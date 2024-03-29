import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/provider/module_id_provider.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/screens/display_material_screen.dart';
import 'package:ug_hub/screens/display_question_paper_screen.dart';
import 'package:ug_hub/unity_ads/unity_ads_class.dart';
import 'package:ug_hub/unity_ads/unity_provider.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import 'package:ug_hub/widgets/module_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/firebase_fields.dart';
import '../functions/reset_material_status.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../utils/color.dart';

class SubjectBanner extends StatelessWidget {
  const SubjectBanner(
      {Key? key,
      required this.snapshot,
      required this.indexofSubject,
      required this.subId,
      required this.context3})
      : super(key: key);
  final String subId;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int indexofSubject;
  final BuildContext context3;

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<UserProvider>(context).userModel;
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
                              try {
                                await launchUrl(
                                    Uri.parse(
                                      snapshot.data!.docs[indexofSubject]
                                          .data()['syllabusLink'],
                                    ),
                                    mode: LaunchMode.externalApplication);
                              } on Exception {
                                showSnackbar(context, "Some error occured");
                              }
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
                  .doc(userModel!.university)
                  .collection(collectionBranch)
                  .doc(userModel.branch)
                  .collection(collectionSemester)
                  .doc(userModel.semester)
                  .collection(collectionSubject)
                  .doc(subId)
                  .collection(collectionModule)
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshotModule) {
                if (snapshotModule.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(child: ShimmerWidget()),
                    // child: LoadingAnimationWidget.fourRotatingDots(
                    //     color: primaryColor, size: 50),
                  );
                }
                return SizedBox(
                  width: double.infinity,
                  height: 138,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true, // 1st add
                      itemCount: snapshotModule.data!.docs.length + 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              if (Provider.of<UserProvider>(context,
                                      listen: false)
                                  .userModel!
                                  .expireTime!
                                  .isBefore(DateTime.now())) {
                                //check reward null
                                if (Provider.of<UnityProvider>(context,
                                            listen: false)
                                        .isAdLoaded ==
                                    false) {
                                  //if add not loaded
                                  // print('add iss null');
                                  // AdManager().showRewardedAd(context3);
                                  index == snapshotModule.data!.docs.length
                                      ? Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                          resetMaterialStatus(context);
                                          Provider.of<ModuleIdProvider>(context)
                                              .setModuleId(snapshot.data!
                                                  .docs[indexofSubject].id);
                                          return const DisplayQuestionPaperScreen();
                                        }))
                                      : Provider.of<ModuleModelProvider>(context, listen: false).setModuleModel = ModuleModel(
                                          moduleName: snapshotModule.data!.docs[index]
                                              .data()['name'],
                                          moduleId: snapshotModule
                                              .data!.docs[index].id,
                                          subjectName: snapshot
                                              .data!.docs[indexofSubject]
                                              .data()['fullname'],
                                          subjectId: snapshot
                                              .data!.docs[indexofSubject].id,
                                          subjectShortName: snapshot
                                              .data!.docs[indexofSubject]
                                              .data()['shortName']);

                                  ///
                                  // index == snapshotModule.data!.docs.length
                                  //     ? Navigator.push(context,
                                  //         MaterialPageRoute(builder: (builder) {
                                  //         resetMaterialStatus(context);
                                  //         Provider.of<ModuleIdProvider>(context)
                                  //             .setModuleId(snapshot.data!
                                  //                 .docs[indexofSubject].id);
                                  //         return const DisplayQuestionPaperScreen();
                                  //       }))
                                  if (index !=
                                      snapshotModule.data!.docs.length) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      resetMaterialStatus(context);
                                      return DisplayMaterialsScreen(
                                        sylabusLink: snapshot
                                            .data!.docs[indexofSubject]
                                            .data()['syllabusLink'],
                                      );
                                    }));
                                  }

                                  ///

                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (dialougeBuilder) {
                                        return DialougeWidget(
                                          yesText: "Continue",
                                          noText: "Cancel",
                                          onYes: () {
                                            UnityClass().playAds(context);
                                            Navigator.pop(dialougeBuilder);
                                          },
                                          onNO: () {
                                            Navigator.pop(dialougeBuilder);
                                          },
                                          icon: const FaIcon(
                                              FontAwesomeIcons.rectangleAd),
                                          tittleText:
                                              "You have to watch an Ad to continue",
                                          subText:
                                              "Get Upto 12 Hours and 4 Downloads\n by watching an Ad",
                                        );
                                      });
                                }
                              } else {
                                index == snapshotModule.data!.docs.length
                                    ? Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                        resetMaterialStatus(context);
                                        Provider.of<ModuleIdProvider>(context)
                                            .setModuleId(snapshot
                                                .data!.docs[indexofSubject].id);
                                        return const DisplayQuestionPaperScreen();
                                      }))
                                    : Provider.of<ModuleModelProvider>(context, listen: false)
                                            .setModuleModel =
                                        ModuleModel(
                                            moduleName: snapshotModule.data!.docs[index]
                                                .data()['name'],
                                            moduleId: snapshotModule
                                                .data!.docs[index].id,
                                            subjectName: snapshot
                                                .data!.docs[indexofSubject]
                                                .data()['fullname'],
                                            subjectId: snapshot
                                                .data!.docs[indexofSubject].id,
                                            subjectShortName: snapshot
                                                .data!.docs[indexofSubject]
                                                .data()['shortName']);

                                if (index != snapshotModule.data!.docs.length) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    resetMaterialStatus(context);
                                    return DisplayMaterialsScreen(
                                      sylabusLink: snapshot
                                          .data!.docs[indexofSubject]
                                          .data()['syllabusLink'],
                                    );
                                  }));
                                }
                              }
                            },
                            child: index == snapshotModule.data!.docs.length
                                ? const ModuleListTile(
                                    "Previous Year Question Paper's", "")
                                : ModuleListTile(
                                    snapshotModule.data!.docs[index]
                                        .data()['name'],
                                    "No of module : 5"));
                        // return Text(Index.toString());
                      }),
                );
              }),
        ],
      ),
    );
  }
}
