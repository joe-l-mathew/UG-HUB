// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/upload_pdf_provider.dart';

Future<void> pickPdfFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'pptx']);

  if (result != null) {
    PlatformFile file1 = result.files.first;
    if (file1.size < 10485760) {
      final path = result.files.single.path;
      String temPath = await getTempPath();
      if (path!.contains(".pdf")) {
        try {
          Provider.of<UploadPdfProvider>(context, listen: false)
              .setIsCompressing(true);
          await PdfCompressor.compressPdfFile(
              path, temPath, CompressQuality.HIGH);
          Provider.of<UploadPdfProvider>(context, listen: false)
              .setIsCompressing(false);
          // print("Compress completed");
          // print(temPath);
        } catch (e) {
          temPath = path;
          // print(e);
          // return 'Error';
        }
      } else {
        temPath = path;
      }
      // print(path);

      var file = File(temPath.toString());
      String fileName = result.files.first.name;
      Provider.of<UploadPdfProvider>(context, listen: false).setFileName =
          fileName;
      Provider.of<UploadPdfProvider>(context, listen: false).setFile = file;
    } else {
      showSnackbar(context, "Pick a file lessthan 10MB");
    }
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

Future<String> getTempPath() async {
  var dir = await getExternalStorageDirectory();
  await Directory('${dir!.path}/UploadedPdfs').create(recursive: true);

  String randomString = getRandomString(10);
  String pdfFileName = '$randomString.pdf';
  return '${dir.path}/UploadedPdfs/$pdfFileName';
}
