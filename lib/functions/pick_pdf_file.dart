// import 'dart:io';

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/upload_pdf_provider.dart';

Future<void> pickPdfFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, type: FileType.custom, allowedExtensions: ['pdf']);

  if (result != null) {
    PlatformFile file1 = result.files.first;
    if (file1.size < 5242880) {
      final path = result.files.single.path;
      var file = File(path.toString());
      String fileName = result.files.first.name;
      Provider.of<UploadPdfProvider>(context, listen: false).setFileName =
          fileName;
      Provider.of<UploadPdfProvider>(context, listen: false).setFile =
          file;
    } else {
      showSnackbar(context, "Pick a file lessthan 5MB");
    }
  }
}
