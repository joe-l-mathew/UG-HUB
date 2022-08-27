// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/open_pdf.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewReportScreen extends StatelessWidget {
  Widget getIcon(String type) {
    if (type == "chat") {
      return const Icon(Icons.chat);
    } else if (type == 'pdf') {
      return const Icon(Icons.picture_as_pdf);
    } else if (type == "youtube") {
      return const FaIcon(FontAwesomeIcons.youtube);
    } else {
      return const FaIcon(FontAwesomeIcons.link);
    }
  }

  const ViewReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionReports)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      var path = snapshot.data!.docs[index];
                      return Card(
                        child: ListTile(
                          onTap: () async {
                            if (path['fileType'] == 'pdf') {
                              await openPdf(
                                  context: context,
                                  snapshot: snapshot,
                                  index: index);
                            } else if (path['fileType'] == 'chat') {
                            } else {
                              try {
                                await launchUrl(
                                    Uri.parse(
                                      snapshot.data!.docs[index]['fileUrl'],
                                    ),
                                    mode: LaunchMode.externalApplication);
                              } on Exception {
                                showSnackbar(
                                    context, "File can't be opened Delete");
                              }
                            }
                          },
                          onLongPress: () async {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return DialougeWidget(
                                      yesText: "Remove",
                                      noText: "No",
                                      onYes: () async {
                                        Navigator.pop(builder);
                                        if (path['fileType'] == 'pdf') {
                                          // deletePdf
                                          await Firestoremethods()
                                              .reportDeletePdffromDatabase(
                                                  context: context,
                                                  path: path['docPath'],
                                                  downloadUrl: path['fileUrl']);
                                        } else {
                                          // delete other docs
                                          await Firestoremethods()
                                              .reportDeleteDocs(
                                                  path: path['docPath']);
                                        }
                                        await Firestoremethods()
                                            .reportDeleteDocs(
                                                path: path.reference.path);
                                        // Navigator.pop(builder);
                                      },
                                      onNO: () async {
                                        await Firestoremethods()
                                            .reportDeleteDocs(
                                                path: path.reference.path);
                                        // delete the report
                                        Navigator.pop(builder);
                                      },
                                      icon: const Icon(Icons.delete),
                                      tittleText: "Do you want to remove",
                                      subText:
                                          "on remove the file will be reemoved from database,else report will be deleted");
                                });
                          },
                          isThreeLine: true,
                          trailing: CircleAvatar(
                              backgroundColor: primaryColor,
                              child: getIcon(path['fileType'])),
                          leading: Text("Comment: " + path['comment']),
                          subtitle: path['fileType'] == 'chat'
                              ? Column(
                                  children: [
                                    Text(
                                      "Chat:" + path['chat'],
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const Divider(),
                                    Text("from:" + path['reporterId'])
                                  ],
                                )
                              : Text(path['reporterId']),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemCount: snapshot.data!.docs.length),
              );
            } else {
              return const Center(
                child: Text("Some error occured"),
              );
            }
          }),
    );
  }
}
