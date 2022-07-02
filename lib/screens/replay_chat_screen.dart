import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/chat_replay_model.dart';

import '../constants/firebase_fields.dart';
import '../firebase/firestore_methods.dart';
import '../functions/snackbar_model.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';

class ReplayChatScreen extends StatelessWidget {
  final _replayController = TextEditingController();
  final String? profileUrl;
  final String userName;
  final String chat;
  final String docId;

  ReplayChatScreen(
      {Key? key,
      required this.profileUrl,
      required this.userName,
      required this.chat,
      required this.docId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).userModel;
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
        .instance
        .collection(collectionUniversity)
        .doc(_user!.university!)
        .collection(collectionBranch)
        .doc(_user.branch!)
        .collection(collectionSemester)
        .doc(_user.semester)
        .collection(collectionChat)
        .doc(docId)
        .collection(collectionChatReplay)
        .orderBy('dateTime')
        .snapshots();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Reply"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Card(
              //   child: ListTile(
              //     leading: profileUrl != null
              //         ? CircleAvatar(child: Image.network(profileUrl!))
              //         : const CircleAvatar(
              //             radius: 15,
              //             child: Icon(Icons.person),
              //           ),
              //     title: Text(userName),
              //     subtitle: Text(chat),
              //     isThreeLine: true,
              //     tileColor: Color.fromARGB(179, 182, 186, 236),
              //   ),
              // ),
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
                            child: ListTile(
                              leading: snapshot.data!.docs[index]
                                          ['profileUrl'] !=
                                      null
                                  ? CircleAvatar(
                                      child: Image.network(snapshot
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
                              tileColor: Color.fromARGB(179, 182, 186, 236),
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
                        ? CircleAvatar(child: Image.network(_user.profileUrl!))
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
                                  profileUrl: profileUrl),
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
