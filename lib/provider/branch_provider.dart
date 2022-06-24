import 'package:flutter/material.dart';
class BranchyProvider with ChangeNotifier {
  String? selectedUniversityName;
  String? selectedUniversityDocId;
  setUnivName(String name) {
    selectedUniversityName = name;
    notifyListeners();
  }

  setBranchId(String docId) {
    selectedUniversityDocId = docId;
  }
}
