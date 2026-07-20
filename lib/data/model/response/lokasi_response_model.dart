import 'dart:convert';

class LokasiResponseModel {
  final String message;
  final int statusCode;
  final List<DataLokasi> data;

  LokasiResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory LokasiResponseModel.fromRawJson(String str) =>
      LokasiResponseModel.fromJson(json.decode(str));

  factory LokasiResponseModel.fromJson(Map<String, dynamic> json) =>
      LokasiResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] == null
            ? []
            : List<DataLokasi>.from(
                json["data"].map((x) => DataLokasi.fromJson(x)),
              ),
      );
}

class DataLokasi {
  final int id;
  final int? idProject;
  final String namaProject;
  final String namaLokasi;

  DataLokasi({
    required this.id,
    this.idProject,
    required this.namaProject,
    required this.namaLokasi,
  });

  factory DataLokasi.fromRawJson(String str) =>
      DataLokasi.fromJson(json.decode(str));

  factory DataLokasi.fromJson(Map<String, dynamic> json) => DataLokasi(
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        idProject: json["id_project"] == null
            ? null
            : (json["id_project"] is int
                ? json["id_project"]
                : int.tryParse(json["id_project"].toString())),
        namaProject: json["nama_project"]  ?? '',
        namaLokasi: json["nama_lokasi"] ?? '',
      );
}