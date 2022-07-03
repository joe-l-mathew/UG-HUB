import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/utils/color.dart';

import '../model/module_model.dart';
import '../model/user_model.dart';
import '../provider/module_model_provider.dart';
import '../provider/user_provider.dart';

class DisplayMaterialTile extends StatelessWidget {
  final String docId;
  final String fileName;
  final String uploadedBy;
  final String likeCount;
  final Enum fileType;
  final int index;
  final String collectionName;
  final List likes;

  const DisplayMaterialTile(
      {Key? key,
      required this.fileName,
      required this.uploadedBy,
      required this.likeCount,
      required this.fileType,
      required this.docId,
      required this.index,
      required this.collectionName,
      required this.likes})
      : super(key: key);

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
    Widget getSelectedIcon() {
      if (fileType == FileType.pdf) {
        return const Icon(
          Icons.picture_as_pdf_outlined,
        );
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
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CircleAvatar(
                child: getSelectedIcon(),
                backgroundColor: primaryColor,
                radius: 23,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                fileName,
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
                Text(uploadedBy),
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
                            uid: _user.uid,
                            likes: likes,
                            collectionName: collectionName);
                      },
                      icon: Icon(
                        likes.contains(_user.uid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: likes.contains(_user.uid)
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(179, 182, 186, 236),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 200,
        width: 200,
      ),
    );
  }
}
