import 'dart:convert';

class AksesResponseModel {
  final String message;
  final int statusCode;
  final List<DataAkses> data;

  AksesResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory AksesResponseModel.fromRawJson(String str) =>
      AksesResponseModel.fromJson(json.decode(str));

  factory AksesResponseModel.fromJson(Map<String, dynamic> json) =>
      AksesResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] != null
            ? List<DataAkses>.from(
                json["data"].map(
                  (x) => DataAkses.fromJson(x),
                ),
              )
            : [],
      );
}

class DataAkses {
  final int idAkses;
  final String namaAkses;

  DataAkses({
    required this.idAkses,
    required this.namaAkses,
  });

  factory DataAkses.fromRawJson(String str) =>
      DataAkses.fromJson(json.decode(str));

  factory DataAkses.fromJson(Map<String, dynamic> json) => DataAkses(
        idAkses: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        namaAkses: json["nama_akses"] ?? '',
      );
}