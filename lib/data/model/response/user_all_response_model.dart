import 'dart:convert';

class UserAllResponseModel {
  final String message;
  final int statusCode;
  final List<DataAdminUser> data;

  UserAllResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory UserAllResponseModel.fromRawJson(String str) =>
      UserAllResponseModel.fromJson(json.decode(str));

  factory UserAllResponseModel.fromJson(Map<String, dynamic> json) =>
      UserAllResponseModel(
        message: json["message"] ?? "",
        statusCode: json["status_code"] ?? 0,
        data: json["data"] == null
            ? []
            : List<DataAdminUser>.from(
                json["data"].map((x) => DataAdminUser.fromJson(x)),
              ),
      );
}

class DataAdminUser {
  final int id;
  final int idProject;
  final int idRole;
  final String namaProject;
  final String namaRole;
  final String name;
  final String nip;
  final String notlp;
  final String alamat;
  final String email;

  DataAdminUser({
    required this.id,
    required this.idProject,
    required this.idRole,
    required this.namaProject,
    required this.namaRole,
    required this.name,
    required this.nip,
    required this.notlp,
    required this.alamat,
    required this.email,
  });

  factory DataAdminUser.fromRawJson(String str) =>
      DataAdminUser.fromJson(json.decode(str));

  factory DataAdminUser.fromJson(Map<String, dynamic> json) => DataAdminUser(
        id: json["id"] ?? 0,
        idProject: json["id_project"] ?? 0,
        idRole: json["id_role"] ?? 0,
        namaProject: json["nama_project"] ?? "",
        namaRole: json["nama_role"] ?? "",
        name: json["name"] ?? "",
        nip: json["nip"]?.toString() ?? "",
        notlp: json["notlp"] ?? "",
        alamat: json["alamat"] ?? "",
        email: json["email"] ?? "",
      );
}