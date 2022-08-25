import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:uuid/uuid.dart';

import '../provider/upload_status_provider.dart';
import '../provider/user_provider.dart';

class FirebaseStorageMethods {
  final _stroage = FirebaseStorage.instance;
  Future<String> addPdfToStorage(File pdfFile, BuildContext context) async {
    // print(" storage Started");
    UploadTask task =
        _stroage.ref("PDF").child(const Uuid().v1()).putFile(pdfFile);
    task.snapshotEvents.listen((event) {
      double? progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      Provider.of<UploadStatusProvider>(context, listen: false)
          .setUploadStatus = progress;
    });
    // task.snapshotEvents.listen((event) {
    //   Provider.of<UploadStatusProvider>(context, listen: false)
    //       .setUploadStatus = event.bytesTransferred.toInt();
    // });
    TaskSnapshot snapshot = await task.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    // print(downloadUrl);
    return downloadUrl;
  }

  Future<void> deleteProfiePic(BuildContext context) async {
    UserModel? _user =
        Provider.of<UserProvider>(context, listen: false).userModel;
    if (_user!.profileUrl != null) {
      await FirebaseStorage.instance.refFromURL(_user.profileUrl!).delete();
    }
  }
}
