// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/model/report_model.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import 'package:ug_hub/widgets/report_material.dart';

import '../model/module_model.dart';
import '../model/user_model.dart';
import '../provider/module_model_provider.dart';
import '../provider/user_provider.dart';

class DisplayMaterialTile extends StatelessWidget {
  final String? downloadUrl;
  final String docId;
  final String fileName;
  final String uploadedBy;
  final String likeCount;
  final FileType fileType;
  final int index;
  final String collectionName;
  final List likes;

  final QueryDocumentSnapshot<Map<String, dynamic>> snap;

  const DisplayMaterialTile(
      {Key? key,
      required this.fileName,
      required this.uploadedBy,
      required this.likeCount,
      required this.fileType,
      required this.docId,
      required this.index,
      required this.collectionName,
      required this.likes,
      this.downloadUrl,
      required this.snap})
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
    Widget getSelectedIcon() {
      if (fileType == FileType.pdf) {
        return const FaIcon(FontAwesomeIcons.filePowerpoint);
      } else if (fileType == FileType.youtube) {
        return const FaIcon(
          FontAwesomeIcons.youtube,
        );
      } else {
        return const FaIcon(FontAwesomeIcons.link);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        //long press
        onLongPress: () {
          //for uploader show delete button
          if (user.uid == snap['uid']
              // || _user.isAdmin == true
              ) {
            showDialog(
                context: context,
                builder: (pdfDeleteContext) {
                  return DialougeWidget(
                      yesText: "Delete",
                      noText: "Cancel",
                      onYes: () async {
                        Navigator.pop(pdfDeleteContext);
                        await Firestoremethods().deleteUploadFileFromFirestore(
                            type: fileType, path: path, docid: snap.id);
                      },
                      onNO: () {
                        Navigator.pop(pdfDeleteContext);
                      },
                      icon: const Icon(Icons.delete),
                      tittleText: "Do you want to delete this file",
                      subText: "File will be removed permenently");
                });
            //for other users show report button
          } else {
            showDialog(
                context: context,
                builder: (contextDialouge) {
                  return DialougeWidget(
                      yesText: "Report",
                      noText: "Cancel",
                      onYes: () async {
                        if (fileType == FileType.pdf) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportScreen(
                                        reportModel: ReportModel(
                                          snap['fileUrl'],
                                          null,
                                          null,
                                          docPath: snap.reference.path,
                                          fileType: fileType,
                                          reporterId: user.uid,
                                        ),
                                      )));
                          Navigator.pop(contextDialouge);
                        } else if (fileType == FileType.youtube) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportScreen(
                                        reportModel: ReportModel(
                                          snap['youtubeLink'],
                                          null,
                                          null,
                                          docPath: snap.reference.path,
                                          fileType: fileType,
                                          reporterId: user.uid,
                                        ),
                                      )));
                          Navigator.pop(contextDialouge);
                        } else if (fileType == FileType.link) {
                          Navigator.pop(contextDialouge);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportScreen(
                                        reportModel: ReportModel(
                                          snap['link'],
                                          null,
                                          null,
                                          docPath: snap.reference.path,
                                          fileType: fileType,
                                          reporterId: user.uid,
                                        ),
                                      )));
                          Navigator.pop(contextDialouge);
                        }
                      },
                      onNO: () {
                        Navigator.pop(contextDialouge);
                      },
                      icon: const Icon(Icons.report),
                      tittleText: 'Report this material',
                      subText: "Do you want to report");
                });
          }

          //show dialouge to delete the doc with firestorage storage delete
          //delete from firestore,
        },
        // onLongPress: () {
        //   if (_user.uid != snapshot.data!.docs[index]['uid'])
        //     showDialog(
        //         context: context,
        //         builder: (contextDialouge) {
        //           return DialougeWidget(
        //               yesText: "Report",
        //               noText: "Cancel",
        //               onYes: () async {
        //                 await Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => const ReportScreen()));
        //                 Navigator.pop(contextDialouge);
        //               },
        //               onNO: () {
        //                 Navigator.pop(contextDialouge);
        //               },
        //               icon: Icon(Icons.report),
        //               tittleText: 'Report this material',
        //               subText: "Do you want to report");
        //         });
        // },
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(179, 182, 186, 236),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 200,
          width: 200,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 23,
                  child: getSelectedIcon(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  fileName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      uploadedBy,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(likeCount),
                      IconButton(
                        onPressed: () {
                          // Firestoremethods().addALike(
                          //     path: path,
                          //     context: context,
                          //     index: index,
                          //     collectionName: collectionName,
                          //     docId: docId);
                          Firestoremethods().likePost(
                              path: path,
                              docId: docId,
                              uid: user.uid,
                              likes: likes,
                              collectionName: collectionName);
                        },
                        icon: Icon(
                          likes.contains(user.uid)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: likes.contains(user.uid)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
