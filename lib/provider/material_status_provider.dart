import 'package:flutter/material.dart';

enum MaterialStatus { loading, loaded, empty }

class MaterialStatusProvider with ChangeNotifier {
  MaterialStatus pdfStatus = MaterialStatus.loading;
  MaterialStatus ytStatus = MaterialStatus.loading;
  MaterialStatus linkStatus = MaterialStatus.loading;
  setPdfStatus(MaterialStatus status) {
    pdfStatus = status;
    notifyListeners();
  }

  setYtStatus(MaterialStatus status) {
    pdfStatus = status;
    notifyListeners();
  }

  setLinkStatus(MaterialStatus status) {
    pdfStatus = status;
    notifyListeners();
  }
}
