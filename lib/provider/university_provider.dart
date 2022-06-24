import 'package:flutter/material.dart';

class UniversityProvider with ChangeNotifier {
  String? selectedUniversityName;
  String? selectedUniversityDocId;
  setUnivName(String name) {
    selectedUniversityName = name;
    notifyListeners();
  }

  setUnivId(String docId) {
    selectedUniversityDocId = docId;
  }
}