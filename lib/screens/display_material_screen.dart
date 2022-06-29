import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/model/upload_pdf_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/screens/add_materials.dart';
import 'package:ug_hub/utils/color.dart';

import '../constants/firebase_fields.dart';
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
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => AddMaterialsScreen()));
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
                  stream: path.collection(collectionPdf).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //need to change progress indicator
                      return Center(
                          child: LoadingAnimationWidget.waveDots(
                              color: Colors.white, size: 14));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Container();
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
                              return DisplayMaterialTile(
                                fileName: snapshot.data!.docs[index]
                                    ['fileName'],
                                fileType: FileType.pdf,
                                likeCount: "100",
                                // likeCount: snapshot.data!.docs[index]['likes'].length.,
                                uploadedBy: snapshot.data!.docs[index]
                                    ['userName'],
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
                      return Container();
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
                              return DisplayMaterialTile(
                                fileName: snapshot.data!.docs[index]
                                    ['youtubeChannelName'],
                                fileType: FileType.youtube,
                                likeCount: "100",
                                // likeCount: snapshot.data!.docs[index]['likes'].length.,
                                uploadedBy: snapshot.data!.docs[index]
                                    ['userName'],
                              );
                            }),
                      );
                    }
                  },
                ),
              ]),
              const Divider(),
              //other links

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
                      return Container();
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
                              return DisplayMaterialTile(
                                fileName: snapshot.data!.docs[index]
                                    ['linkName'],
                                fileType: FileType.link,
                                likeCount: "100",
                                // likeCount: snapshot.data!.docs[index]['likes'].length.,
                                uploadedBy: snapshot.data!.docs[index]
                                    ['userName'],
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
