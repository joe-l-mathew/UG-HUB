import 'package:flutter/cupertino.dart';

class UploadStatusProvider with ChangeNotifier {
  double? uploadStatus;

  set setUploadStatus(double? uploasStatusNumber) {
    uploadStatus = uploasStatusNumber;
    notifyListeners();
  }
}
