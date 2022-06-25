import 'package:flutter/material.dart';
import 'package:ug_hub/model/branch_model.dart';

class BranchProvider with ChangeNotifier {
  BranchModel? branchModel;

  void setBranchModel(BranchModel model) {
    branchModel = model;
    notifyListeners();
  }

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
