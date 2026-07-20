import 'dart:convert';

class RoleResponseModel {
  final String message;
  final int statusCode;
  final List<DataRole> data;

  RoleResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory RoleResponseModel.fromRawJson(String str) =>
      RoleResponseModel.fromJson(json.decode(str));

  factory RoleResponseModel.fromJson(Map<String, dynamic> json) =>
      RoleResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] != null
            ? List<DataRole>.from(
                json["data"].map(
                  (x) => DataRole.fromJson(x),
                ),
              )
            : [],
      );
}

class DataRole {
  final int idRole;
  final String namaRole;

  DataRole({
    required this.idRole,
    required this.namaRole,
  });

  factory DataRole.fromRawJson(String str) =>
      DataRole.fromJson(json.decode(str));

  factory DataRole.fromJson(Map<String, dynamic> json) => DataRole(
        idRole: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        namaRole: json["nama_role"] ?? '',
      );
}