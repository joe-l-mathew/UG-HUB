import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/chat_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/replay_chat_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
        .snapshots();

    final _chatController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
        ),
        body: Column(
          children: [
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
                    controller: _chatController,
                    style: const TextStyle(),
                  )),
                  TextButton(
                      onPressed: () async {
                        if (_chatController.text.isNotEmpty) {
                          await Firestoremethods().addAChat(
                              context: context,
                              chatModel: ChatModel(
                                  chat: _chatController.text,
                                  username: _user.name!,
                                  uid: _user.uid,
                                  dateTime: DateTime.now(),
                                  profileUrl: _user.profileUrl));
                          _chatController.clear();
                        } else {
                          showSnackbar(context, "Please enter some text");
                        }
                      },
                      child: const Text('Post'))
                ],
              ),
            ),
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
                                title: Text(
                                    snapshot.data!.docs[index]['username']),
                                subtitle:
                                    Text(snapshot.data!.docs[index]['chat']),
                                isThreeLine: true,
                                tileColor: Color.fromARGB(179, 182, 186, 236),
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReplayChatScreen(
                                                    userName: snapshot
                                                            .data!.docs[index]
                                                        ['username'],
                                                    chat: snapshot.data!
                                                        .docs[index]['chat'],
                                                    profileUrl: snapshot
                                                            .data!.docs[index]
                                                        ['profileUrl'],
                                                    docId: snapshot
                                                        .data!.docs[index].id,
                                                  )));
                                    },
                                    icon: Icon(Icons.reply_rounded))));
                      },
                    ),
                  );
                }),
          ],
        ));
  }
}
