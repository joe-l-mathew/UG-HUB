import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/chat_replay_model.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';

import '../constants/firebase_fields.dart';
import '../firebase/firestore_methods.dart';
import '../functions/snackbar_model.dart';
import '../model/report_model.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../widgets/report_material.dart';

class ReplayChatScreen extends StatelessWidget {
  final _replayController = TextEditingController();
  // final String? profileUrl;
  final String userName;
  final String chat;
  final String docId;

  ReplayChatScreen(
      {Key? key,
      // required this.profileUrl,
      required this.userName,
      required this.chat,
      required this.docId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).userModel;
    var path = FirebaseFirestore.instance
        .collection(collectionUniversity)
        .doc(_user!.university!)
        .collection(collectionBranch)
        .doc(_user.branch!)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionChat)
        .doc(docId)
        .collection(collectionChatReplay);
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
        path.orderBy('dateTime').snapshots();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Reply"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder(
                  stream: snapshot,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: LinearProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: ListTile(
                              onLongPress: () {
                                if (snapshot.data!.docs[index]['uid'] ==
                                        _user.uid
                                    //      ||
                                    // _user.isAdmin == true
                                    ) {
                                  showDialog(
                                      context: context,
                                      builder: (dialougeBuilder) {
                                        return DialougeWidget(
                                            yesText: "Delete",
                                            noText: "No",
                                            onYes: () async {
                                              Navigator.pop(dialougeBuilder);
                                              await path
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();
                                              // Navigator.pop(dialougeBuilder);
                                            },
                                            onNO: () {
                                              Navigator.pop(dialougeBuilder);
                                            },
                                            icon: const Icon(Icons.delete),
                                            tittleText: "Do you want to delete",
                                            subText: "");
                                      });
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
                                                      builder: (context) =>
                                                          ReportScreen(
                                                            reportModel: ReportModel(
                                                                null,
                                                                null,
                                                                snapshot.data!
                                                                            .docs[
                                                                        index]
                                                                    ['chat'],
                                                                docPath: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .reference
                                                                    .path,
                                                                fileType:
                                                                    FileType
                                                                        .chat,
                                                                reporterId:
                                                                    _user.uid),
                                                          )));
                                              Navigator.pop(contextDialouge);
                                            },
                                            onNO: () {
                                              Navigator.pop(contextDialouge);
                                            },
                                            icon: const Icon(Icons.report),
                                            tittleText: 'Report this chat',
                                            subText: "Do you want to report");
                                      });
                                }
                              },
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              leading: snapshot.data!.docs[index]
                                          ['profileUrl'] !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(snapshot
                                              .data!.docs[index]['profileUrl']))
                                  : const CircleAvatar(
                                      radius: 15,
                                      child: Icon(Icons.person),
                                    ),
                              title:
                                  Text(snapshot.data!.docs[index]['username']),
                              subtitle:
                                  Text(snapshot.data!.docs[index]['chat']),
                              isThreeLine: true,
                              tileColor:
                                  const Color.fromARGB(179, 182, 186, 236),
                            ),
                          );
                        },
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _user.profileUrl != null
                        ? CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(_user.profileUrl!),
                          )
                        : const CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.person),
                          ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Enter your message here'),
                      controller: _replayController,
                      style: const TextStyle(),
                    )),
                    TextButton(
                        onPressed: () async {
                          if (_replayController.text.isNotEmpty) {
                            await Firestoremethods().addReplay(
                              context: context,
                              chatReplayModel: ChatReplayModel(
                                  chat: _replayController.text,
                                  username: _user.name!,
                                  uid: _user.uid,
                                  dateTime: DateTime.now(),
                                  chatId: docId,
                                  profileUrl: _user.profileUrl),
                            );
                            _replayController.clear();
                          } else {
                            showSnackbar(context, "Please enter some text");
                          }
                        },
                        child: const Text('Post'))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
