class ModuleModel {
  final String moduleName;
  final String moduleId;
  final String subjectName;
  final String subjectId;
  final String subjectShortName;

  ModuleModel(
      {required this.moduleName,
      required this.subjectShortName,
      required this.moduleId,
      required this.subjectName,
      required this.subjectId});

  Map<String, dynamic> toJson(ModuleModel moduleModel) {
    return {
      "moduleName": moduleName,
      "moduleId": moduleId,
      "subjectName": subjectName,
      "subjectId": subjectId,
      "subjectShortName": subjectShortName
    };
  }
}
