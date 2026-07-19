import 'dart:convert';

class ProjectRequestModel {
  final String namaProject;

  ProjectRequestModel({
    required this.namaProject,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "nama_project": namaProject,
      };
}