import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/show_terms_and_condition.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/screens/add_materials.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import 'package:ug_hub/widgets/report_material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/firebase_fields.dart';
import '../provider/add_module_toggle_provider.dart';
import '../provider/user_provider.dart';
import '../widgets/display_file_tile.dart';

class DisplayMaterialsScreen extends StatelessWidget {
  const DisplayMaterialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModuleModel? _moduleModel =
        Provider.of<ModuleModelProvider>(context).getModuleModel;

    UserModel _user =
        Provider.of<UserProvider>(context, listen: false).userModel!;
    var path = FirebaseFirestore.instance
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

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const AddMaterialsScreen()));
            }
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(_moduleModel.moduleName +
                " (" +
                _moduleModel.subjectShortName +
                ")")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //List PDF
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "PDF",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: path
                      .collection(collectionPdf)
                      .orderBy('userName')
                      .snapshots(),
                  builder: (BuildContext contexts,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //need to change progress indicator
                      return Center(
                          child: LoadingAnimationWidget.waveDots(
                              color: Colors.white, size: 14));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(child: ShimmerWidget()),
                      );
                    } else {
                      return SizedBox(
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
                                  if (_user.uid ==
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
                                  ProgressDialog pr = ProgressDialog(context);
                                  pr = ProgressDialog(context,
                                      type: ProgressDialogType.download,
                                      isDismissible: false,
                                      showLogs: true);
                                  pr.style(
                                      message: 'Downloading file...',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      progressWidget: Center(
                                        child: LoadingAnimationWidget.inkDrop(
                                            color: primaryColor, size: 14),
                                      ),
                                      elevation: 10.0,
                                      insetAnimCurve: Curves.easeInOut,
                                      progress: 0.0,
                                      textAlign: TextAlign.center,
                                      maxProgress: 100.0,
                                      progressTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 0,
                                          fontWeight: FontWeight.w400),
                                      messageTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600));
                                  await pr.show();
                                  var file = await DefaultCacheManager()
                                      .getSingleFile(snapshot.data!.docs[index]
                                          ['fileUrl']);
                                  await pr.hide();
                                  OpenFile.open(
                                    file.path,
                                  );
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
                      );
                    }
                  },
                ),
              ]),
              const Divider(),
              //show youtube files
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Youtube",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: path.collection(collectionYoutube).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //need to change progress indicator
                      return Center(
                        child: LoadingAnimationWidget.waveDots(
                            color: Colors.white, size: 14),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const ShimmerWidget();
                    } else {
                      return SizedBox(
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
                                onLongPress: () {
                                  if (_user.uid ==
                                      snapshot.data!.docs[index]['uid']) {
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
                                                        type: FileType.youtube,
                                                        path: path,
                                                        docid: snapshot.data!
                                                            .docs[index].id);
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
                                  await launchUrl(
                                      Uri.parse(
                                        snapshot.data!.docs[index]
                                            ['youtubeLink'],
                                      ),
                                      mode: LaunchMode.externalApplication);
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
                      );
                    }
                  },
                ),
              ]),
              const Divider(),

              //other links//

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Other links",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: path.collection(collectionOtherLink).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //need to change progress indicator
                      return Center(
                          child: LoadingAnimationWidget.waveDots(
                              color: Colors.white, size: 14));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const ShimmerWidget();
                    } else {
                      return SizedBox(
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
                                onTap: () {
                                  launchUrl(
                                      Uri.parse(
                                          snapshot.data!.docs[index]['link']),
                                      mode: LaunchMode.externalApplication);
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
                      );
                    }
                  },
                ),
              ]),
            ],
          ),
        ));
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
