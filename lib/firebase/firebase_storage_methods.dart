import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/provider/upload_pdf_provider.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageMethods {
  final _stroage = FirebaseStorage.instance;
  Future<String> addPdfToStorage(File pdfFile, BuildContext context) async {
    TaskSnapshot snapshot = await _stroage.ref("PDF").child(Uuid().v1()).putFile(pdfFile);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("download Url:" + downloadUrl);
    return downloadUrl;
  }
}
