import 'package:flutter/cupertino.dart';

class DisplayPdfProvider with ChangeNotifier {
  bool isDownloading = false;
  Future<void> setIsDownloading(bool isDownloadingfun) async {
    isDownloading = isDownloadingfun;
    notifyListeners();
  }
}
