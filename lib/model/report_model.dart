import 'package:ug_hub/constants/firebase_fields.dart';

class ReportModel {
  final String docPath;
  final FileType fileType;
  final String? fileUrl;
  String? comment;
  final String reporterId;
  final bool isSolved;

  ReportModel(this.fileUrl, this.comment, this.isSolved,
      {required this.docPath,
      required this.fileType,
      required this.reporterId});

  Map<String, dynamic> toJson() {
    return {
      "docPath": docPath,
      "fileType": fileType.name,
      "fileUrl": fileUrl,
      "comment": comment,
      "reporterId": reporterId,
      "isSolved": false
    };
  }
}
