import 'package:flutter/material.dart';

enum MaterialStatus { loading, loaded, empty }

class MaterialStatusProvider with ChangeNotifier {
  MaterialStatus pdfStatus = MaterialStatus.loading;
  MaterialStatus ytStatus = MaterialStatus.loading;
  MaterialStatus linkStatus = MaterialStatus.loading;
  setPdfStatus(MaterialStatus status) {
    pdfStatus = status;
    print(pdfStatus);
    notifyListeners();
  }

  setYtStatus(MaterialStatus status) {
    ytStatus = status;
    print(ytStatus);
    notifyListeners();
  }

  setLinkStatus(MaterialStatus status) {
    linkStatus = status;
    print(linkStatus);
    notifyListeners();
  }
}
