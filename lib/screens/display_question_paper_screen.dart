import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/functions/open_pdf.dart';
import 'package:ug_hub/provider/module_id_provider.dart';
import '../constants/firebase_fields.dart';
import '../firebase/firestore_methods.dart';
import '../model/report_model.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
// import '../widgets/add_material_types_widgets.dart';
import '../widgets/dialouge_widget.dart';
import '../widgets/report_material.dart';
import 'add_question_screen.dart';

class DisplayQuestionPaperScreen extends StatelessWidget {
  const DisplayQuestionPaperScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _firestore = FirebaseFirestore.instance;
    var _firebaseStorage = FirebaseStorage.instance;
    UserModel? _user = Provider.of<UserProvider>(context).userModel;
    var pathx = FirebaseFirestore.instance
        .collection(collectionUniversity)
        .doc(_user!.university!)
        .collection(collectionBranch)
        .doc(_user.branch!)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionSubject)
        .doc(Provider.of<ModuleIdProvider>(context, listen: false).moduleid);
    var path = pathx.collection(collectionQuestions);

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
        path.orderBy('fileName', descending: true).snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous year questions"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddQuestionPaperScreen()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream: snapshot,
        // initialData: initialData,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_File_bundle_re_6q1e%201.png?alt=media&token=297b0f81-a805-4a93-858c-32783fcacb50",
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("No material found!")
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var snap = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: ListTile(
                    onTap: () {
                      openPdf(
                          context: context, snapshot: snapshot, index: index);
                    },
                    onLongPress: () {
                      //for uploader show delete button
                      if (_user.uid == snap['uid']
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
                                    _firebaseStorage
                                        .refFromURL(snap['fileUrl'])
                                        .delete();
                                    _firestore
                                        .doc(snap.reference.path)
                                        .delete();
                                    // await Firestoremethods()
                                    //     .deleteUploadFileFromFirestore(
                                    //         type: FileType.pdf,
                                    //         path: pathx,
                                    //         docid: snap.id);
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
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReportScreen(
                                                  reportModel: ReportModel(
                                                    snap['fileUrl'],
                                                    null,
                                                    null,
                                                    docPath:
                                                        snap.reference.path,
                                                    fileType: FileType.pdf,
                                                    reporterId: _user.uid,
                                                  ),
                                                )));
                                    Navigator.pop(contextDialouge);
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
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // isThreeLine: true,
                    leading:
                        const CircleAvatar(child: Icon(Icons.picture_as_pdf)),
                    tileColor: const Color.fromARGB(179, 182, 186, 236),
                    title: Text(snapshot.data!.docs[index]['fileName']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${snapshot.data!.docs[index]['userName']}"),
                        Text(
                            "likes: ${snapshot.data!.docs[index]['likes'].length.toString()}")
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // Firestoremethods().addALike(
                        //     path: path,
                        //     context: context,
                        //     index: index,
                        //     collectionName: collectionName,
                        //     docId: docId);
                        Firestoremethods().likePost(
                            path: pathx,
                            docId: snapshot.data!.docs[index].id,
                            uid: _user.uid,
                            likes: snapshot.data!.docs[index]['likes'],
                            collectionName: collectionQuestions);
                      },
                      icon: Icon(
                        snapshot.data!.docs[index]['likes'].contains(_user.uid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: snapshot.data!.docs[index]['likes']
                                .contains(_user.uid)
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
              // separatorBuilder: (BuildContext context, int index) {
              //   return null;
              // },
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
      ),
    );
  }
}
