import 'dart:convert';

class RoleAksesResponseModel {
  final String message;
  final int statusCode;
  final List<DataRoleAkses> data;

  RoleAksesResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory RoleAksesResponseModel.fromRawJson(String str) =>
      RoleAksesResponseModel.fromJson(json.decode(str));

  factory RoleAksesResponseModel.fromJson(Map<String, dynamic> json) =>
      RoleAksesResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] == null
            ? []
            : List<DataRoleAkses>.from(
                json["data"].map((x) => DataRoleAkses.fromJson(x)),
              ),
      );
}

class DataRoleAkses {
  final int idRole;
  final String namaRole;
  final List<AksesRole> akses;

  DataRoleAkses({
    required this.idRole,
    required this.namaRole,
    required this.akses,
  });

  factory DataRoleAkses.fromJson(Map<String, dynamic> json) =>
      DataRoleAkses(
        idRole: json["id_role"] is int
            ? json["id_role"]
            : int.tryParse(json["id_role"].toString()) ?? 0,
        namaRole: json["nama_role"] ?? '',
        akses: json["akses"] == null
            ? []
            : List<AksesRole>.from(
                json["akses"].map((x) => AksesRole.fromJson(x)),
              ),
      );
}

class AksesRole {
  final int idRoleAkses;
  final int idAkses;
  final String namaAkses;

  AksesRole({
    required this.idRoleAkses,
    required this.idAkses,
    required this.namaAkses,
  });

  factory AksesRole.fromJson(Map<String, dynamic> json) =>
      AksesRole(
        idRoleAkses: json["id_role_akses"] is int
            ? json["id_role_akses"]
            : int.tryParse(json["id_role_akses"].toString()) ?? 0,
        idAkses: json["id_akses"] is int
            ? json["id_akses"]
            : int.tryParse(json["id_akses"].toString()) ?? 0,
        namaAkses: json["nama_akses"] ?? '',
      );
}