import 'package:flutter/material.dart';

class BranchProvider with ChangeNotifier {
  String? selectedBranchName;
  String? selectedBranchDocId;
  setBranchName(String name) {
    selectedBranchName = name;
    notifyListeners();
  }

  setBranchId(String docId) {
    selectedBranchDocId = docId;
  }
}
