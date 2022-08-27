// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';

//////////////////////////////////////////////
/////////////////////////////////////////
///////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/check_internet.dart';
import 'package:ug_hub/functions/open_pdf.dart';
import 'package:ug_hub/functions/show_terms_and_condition.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/model/report_model.dart';
// import 'package:ug_hub/model/subject_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/material_status_provider.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/screens/add_materials.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/firebase_fields.dart';
import '../provider/add_module_toggle_provider.dart';
import '../provider/user_provider.dart';
import '../widgets/display_file_tile.dart';
import '../widgets/no_material_and_loading_material_widget.dart';

//fix sylabus issue

class DisplayMaterialsScreen extends StatelessWidget {
  final String sylabusLink;
  const DisplayMaterialsScreen({Key? key, required this.sylabusLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModuleModel? moduleModel =
        Provider.of<ModuleModelProvider>(context).getModuleModel;

    UserModel user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    var path = FirebaseFirestore.instance
        .collection(collectionUniversity)
        .doc(user.university)
        .collection(collectionBranch)
        .doc(user.branch)
        .collection(collectionSemester)
        .doc(user.semester)
        .collection(collectionSubject)
        .doc(moduleModel!.subjectId)
        .collection(collectionModule)
        .doc(moduleModel.moduleId);
    // var path2 = FirebaseFirestore.instance
    //     .collection(collectionUniversity)
    //     .doc(user.university)
    //     .collection(collectionBranch)
    //     .doc(user.branch)
    //     .collection(collectionSemester)
    //     .doc(user.semester)
    //     .collection(collectionSubject)
    //     .doc(moduleModel.subjectId);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (Provider.of<UserProvider>(context, listen: false)
                      .userModel!
                      .isTermsAccepted ==
                  null ||
              Provider.of<UserProvider>(context, listen: false)
                      .userModel!
                      .isTermsAccepted ==
                  false) {
            showTermsAndCondition(context);
          } else {
            Provider.of<AddModuleToggleProvider>(context, listen: false)
                .setSelectedField = 0;
            bool isConnected = await checkInternet();
            if (isConnected) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const AddMaterialsScreen()));
            } else {
              showSnackbar(context, "Please connect to internet");
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          actions: [
            IconButton(
                tooltip: "Syllabus",
                onPressed: () async {
                  // SubjectModel model =
                  //     SubjectModel.fromSnap(await path2.get());
                  try {
                    await launchUrl(Uri.parse(sylabusLink),
                        mode: LaunchMode.externalApplication);
                  } on Exception {
                    showSnackbar(context, "Some error occured");
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.fileLines))
          ],
          backgroundColor: primaryColor,
          title: Text(
              "${moduleModel.moduleName} (${moduleModel.subjectShortName})")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //List PDF
            StreamBuilder(
              stream: path
                  .collection(collectionPdf)
                  .orderBy('fileName')
                  .snapshots(),
              builder: (BuildContext contexts,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   Provider.of<MaterialStatusProvider>(context,
                  //           listen: false)
                  //       .setPdfStatus(MaterialStatus.loading);
                  // });
                  //need to change progress indicator

                  // return const SizedBox(
                  //     width: double.infinity,
                  //     child: SingleChildScrollView(child: ShimmerWidget()));
                  return const SizedBox.shrink();
                } else if (snapshot.data!.docs.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Add Your Code here.
                    Provider.of<MaterialStatusProvider>(context, listen: false)
                        .setPdfStatus(MaterialStatus.empty);
                  });

                  // return const AddNoMaterial(
                  //   displayText: 'Add PDF / PPT',
                  // );
                  return const SizedBox.shrink();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Add Your Code here.
                    Provider.of<MaterialStatusProvider>(context, listen: false)
                        .setPdfStatus(MaterialStatus.loaded);
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "PDF / PPT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder:
                                (BuildContext contextbuilder, int index) {
                              // bool isLiked = false;
                              // if (snapshot.data!.docs[index]['likes']
                              //     .contains(_user.uid)) {
                              //   isLiked = true;
                              // } else {
                              //   isLiked = false;
                              // }
                              return GestureDetector(
                                onLongPress: () {
                                  if (user.uid ==
                                          snapshot.data!.docs[index]['uid']
                                      //     ||
                                      // _user.isAdmin!
                                      ) {
                                    showDialog(
                                        context: context,
                                        builder: (pdfDeleteContext) {
                                          return DialougeWidget(
                                              yesText: "Delete",
                                              noText: "Cancel",
                                              onYes: () async {
                                                Navigator.pop(pdfDeleteContext);
                                                await Firestoremethods()
                                                    .deleteUploadFileFromFirestore(
                                                        type: FileType.pdf,
                                                        path: path,
                                                        docid: snapshot.data!
                                                            .docs[index].id);
                                                //delete form storage
                                                await Firestoremethods()
                                                    .deleteUploadFileFromStorage(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['fileUrl']);
                                              },
                                              onNO: () {
                                                Navigator.pop(pdfDeleteContext);
                                              },
                                              icon: const Icon(Icons.delete),
                                              tittleText:
                                                  "Do you want to delete this file",
                                              subText:
                                                  "File will be removed permenently");
                                        });
                                  }

                                  //show dialouge to delete the doc with firestorage storage delete
                                  //delete from firestore,
                                },
                                onTap: () async {
                                  openPdf(
                                      context: context,
                                      snapshot: snapshot,
                                      index: index);
                                },
                                child: DisplayMaterialTile(
                                  snap: snapshot.data!.docs[index],
                                  likes: snapshot.data!.docs[index]['likes'],
                                  collectionName: collectionPdf,
                                  index: index,
                                  docId: snapshot.data!.docs[index].id,
                                  fileName: snapshot.data!.docs[index]
                                      ['fileName'],
                                  fileType: FileType.pdf,
                                  likeCount: snapshot
                                      .data!.docs[index]['likes'].length
                                      .toString(),
                                  // likeCount: snapshot.data!.docs[index]['likes'].length.,
                                  uploadedBy: snapshot.data!.docs[index]
                                      ['userName'],
                                ),
                              );
                            }),
                      ),
                      const Divider(),
                    ],
                  );
                }
              },
            ),

            //show youtube files
            StreamBuilder(
              stream: path
                  .collection(collectionYoutube)
                  .orderBy('youtubeChannelName')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   // Add Your Code here.
                  //   Provider.of<MaterialStatusProvider>(context,
                  //           listen: false)
                  //       .setYtStatus(MaterialStatus.loading);
                  // });
                  //need to change progress indicator
                  // return const SizedBox(
                  //   width: double.infinity,
                  //   child: SingleChildScrollView(child: ShimmerWidget()),
                  // );
                  return const SizedBox.shrink();
                } else if (snapshot.data!.docs.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Add Your Code here.
                    Provider.of<MaterialStatusProvider>(context, listen: false)
                        .setYtStatus(MaterialStatus.empty);
                  });
                  // return const AddNoMaterial(
                  //     displayText: "Add Youtube Link");
                  return const SizedBox.shrink();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Add Your Code here.
                    Provider.of<MaterialStatusProvider>(context, listen: false)
                        .setYtStatus(MaterialStatus.loaded);
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Youtube",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              // bool isLiked = false;
                              // if (snapshot.data!.docs[index]['likes']
                              //     .contains(_user.uid)) {
                              //   isLiked = true;
                              // } else {
                              //   isLiked = false;
                              // }
                              return GestureDetector(
                                // onLongPress: () {
                                // if (_user.uid ==
                                //     snapshot.data!.docs[index]['uid']) {
                                //   showDialog(
                                //       context: context,
                                //       builder: (pdfDeleteContext) {
                                //         return DialougeWidget(
                                //             yesText: "Delete",
                                //             noText: "Cancel",
                                //             onYes: () async {
                                //               Navigator.pop(pdfDeleteContext);
                                //               await Firestoremethods()
                                //                   .deleteUploadFileFromFirestore(
                                //                       type: FileType.youtube,
                                //                       path: path,
                                //                       docid: snapshot.data!
                                //                           .docs[index].id);
                                //             },
                                //             onNO: () {
                                //               Navigator.pop(pdfDeleteContext);
                                //             },
                                //             icon: const Icon(Icons.delete),
                                //             tittleText:
                                //                 "Do you want to delete this file",
                                //             subText:
                                //                 "File will be removed permenently");
                                //       });
                                // }

                                //show dialouge to delete the doc with firestorage storage delete
                                //delete from firestore,
                                // },
                                onTap: () async {
                                  try {
                                    await launchUrl(
                                        Uri.parse(
                                          snapshot.data!.docs[index]
                                              ['youtubeLink'],
                                        ),
                                        mode: LaunchMode.externalApplication);
                                  } on Exception {
                                    showSnackbar(
                                        context, "Youtube link unavailable");
                                    await Firestoremethods().addReport(
                                        ReportModel(
                                            snapshot.data!.docs[index]
                                                ['youtubeLink'],
                                            "Admin:Video not Launched",
                                            null,
                                            docPath: snapshot.data!.docs[index]
                                                .reference.path,
                                            fileType: FileType.youtube,
                                            reporterId: user.uid));
                                  }
                                },
                                child: DisplayMaterialTile(
                                  snap: snapshot.data!.docs[index],
                                  //might change
                                  likes: snapshot.data!.docs[index]['likes'],
                                  collectionName: collectionYoutube,
                                  index: index,
                                  docId: snapshot.data!.docs[index].id,
                                  fileName: snapshot.data!.docs[index]
                                      ['youtubeChannelName'],
                                  fileType: FileType.youtube,
                                  likeCount: snapshot
                                      .data!.docs[index]['likes'].length
                                      .toString(),
                                  // likeCount: snapshot.data!.docs[index]['likes'].length.,
                                  uploadedBy: snapshot.data!.docs[index]
                                      ['userName'],
                                ),
                              );
                            }),
                      ),
                      const Divider(),
                    ],
                  );
                }
              },
            ),

            //other links//

            StreamBuilder(
              stream: path.collection(collectionOtherLink).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   // Add Your Code here.
                  //   Provider.of<MaterialStatusProvider>(context,
                  //           listen: false)
                  //       .setLinkStatus(MaterialStatus.loading);
                  // });
                  // //need to change progress indicator
                  // return const SizedBox(
                  //   width: double.infinity,
                  //   child: SingleChildScrollView(child: ShimmerWidget()),
                  // );
                  return const SizedBox.shrink();
                } else if (snapshot.data!.docs.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Add Your Code here.
                    Provider.of<MaterialStatusProvider>(context, listen: false)
                        .setLinkStatus(MaterialStatus.empty);
                  });
                  // return const AddNoMaterial(
                  //     displayText: "Add Other Links");
                  return const SizedBox.shrink();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Add Your Code here.
                    Provider.of<MaterialStatusProvider>(context, listen: false)
                        .setLinkStatus(MaterialStatus.loaded);
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Other links",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              // bool isLiked = false;
                              // if (snapshot.data!.docs[index]['likes']
                              //     .contains(_user.uid)) {
                              //   isLiked = true;
                              // } else {
                              //   isLiked = false;
                              // }
                              return GestureDetector(
                                onTap: () async {
                                  //check url before launch
                                  try {
                                    await launchUrl(
                                        Uri.parse(
                                            snapshot.data!.docs[index]['link']),
                                        mode: LaunchMode.externalApplication);
                                  } on Exception {
                                    showSnackbar(context,
                                        "The given link is unavailable");
                                    await Firestoremethods().addReport(
                                        ReportModel(
                                            snapshot.data!.docs[index]['link'],
                                            "Admin:Link not Launched",
                                            null,
                                            docPath: snapshot.data!.docs[index]
                                                .reference.path,
                                            fileType: FileType.link,
                                            reporterId: user.uid));
                                  }
                                },
                                child: DisplayMaterialTile(
                                  downloadUrl: snapshot.data!.docs[index]
                                      ['link'],
                                  snap: snapshot.data!.docs[index],
                                  likes: snapshot.data!.docs[index]['likes'],
                                  index: index,
                                  collectionName: collectionOtherLink,
                                  docId: snapshot.data!.docs[index].id,
                                  fileName: snapshot.data!.docs[index]
                                      ['linkName'],
                                  fileType: FileType.link,
                                  likeCount: snapshot
                                      .data!.docs[index]['likes'].length
                                      .toString(),
                                  // likeCount: snapshot.data!.docs[index]['likes'].length.,
                                  uploadedBy: snapshot.data!.docs[index]
                                      ['userName'],
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              },
            ),
            const StatusPage(),
          ],
        ),
      ),
    );
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<MaterialStatusProvider>(context).pdfStatus ==
                MaterialStatus.empty &&
            Provider.of<MaterialStatusProvider>(context).ytStatus ==
                MaterialStatus.empty &&
            Provider.of<MaterialStatusProvider>(context).linkStatus ==
                MaterialStatus.empty
        ? const NoMaterialFound()
        : Provider.of<MaterialStatusProvider>(context).pdfStatus ==
                    MaterialStatus.loading &&
                Provider.of<MaterialStatusProvider>(context).ytStatus ==
                    MaterialStatus.loading &&
                Provider.of<MaterialStatusProvider>(context).linkStatus ==
                    MaterialStatus.loading
            ? const MaterialLoadingCustom()
            : const SizedBox.shrink();
  }
}

class AddNoMaterial extends StatelessWidget {
  final String displayText;
  const AddNoMaterial({
    Key? key,
    required this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SimpleBtn1(
            text: displayText,
            onPressed: () async {
              if (Provider.of<UserProvider>(context, listen: false)
                          .userModel!
                          .isTermsAccepted ==
                      null ||
                  Provider.of<UserProvider>(context, listen: false)
                          .userModel!
                          .isTermsAccepted ==
                      false) {
                showTermsAndCondition(context);
              } else {
                Provider.of<AddModuleToggleProvider>(context, listen: false)
                    .setSelectedField = 0;
                bool isConnected = await checkInternet();
                if (isConnected) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const AddMaterialsScreen()));
                } else {
                  showSnackbar(context, "Please connect to internet");
                }
              }
            },
          )),
          Text("No material found, Be the first one to $displayText"),
        ],
      ),
      // child: SingleChildScrollView(child: ShimmerWidget()),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 140,
                  width: 190,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 140,
                  width: 190,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
