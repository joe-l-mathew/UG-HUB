import 'dart:io';

import 'package:flutter/cupertino.dart';

class UploadPdfProvider with ChangeNotifier {
  bool isCompressing = false;
  String? selectedPdfName;
  File? file;
  String? fileUrl;
  String? inputFileName;

  set setFile(File? filefrompackage) {
    file = filefrompackage;
    notifyListeners();
  }

  set setFileUrl(String? fileurlfromfirestorage) {
    fileUrl = fileurlfromfirestorage;
    notifyListeners();
  }

  set setInputFileName(String? fileNamefromfirestorage) {
    inputFileName = fileNamefromfirestorage;
    notifyListeners();
  }

  set setFileName(String? fileNameFromPackage) {
    selectedPdfName = fileNameFromPackage;
    notifyListeners();
  }

  setIsCompressing(bool compressionStat) {
    isCompressing = compressionStat;
    notifyListeners();
  }
}
