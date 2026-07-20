import 'dart:convert';

class ProjectResponseModel {
  final String message;
  final int statusCode;
  final List<DataProject> data;

  ProjectResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory ProjectResponseModel.fromRawJson(String str) =>
      ProjectResponseModel.fromJson(json.decode(str));

  factory ProjectResponseModel.fromJson(Map<String, dynamic> json) =>
      ProjectResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] != null
            ? List<DataProject>.from(
                json["data"].map(
                  (x) => DataProject.fromJson(x),
                ),
              )
            : [],
      );
}

class DataProject {
  final int idProject;
  final String namaProject;

  DataProject({
    required this.idProject,
    required this.namaProject,
  });

  factory DataProject.fromRawJson(String str) =>
      DataProject.fromJson(json.decode(str));

  factory DataProject.fromJson(Map<String, dynamic> json) => DataProject(
        idProject: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        namaProject: json["nama_project"] ?? '',
      );
}