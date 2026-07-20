import 'dart:convert';

class KlienResponseModel {
  final String message;
  final int statusCode;
  final DataKlien? data;

  KlienResponseModel({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory KlienResponseModel.fromRawJson(String str) =>
      KlienResponseModel.fromJson(json.decode(str));

  factory KlienResponseModel.fromJson(Map<String, dynamic> json) =>
      KlienResponseModel(
        message: json["message"] ?? "",
        statusCode: json["status_code"] ?? 0,
        data: json["data"] != null
            ? DataKlien.fromJson(json["data"])
            : null,
      );
}

class DataKlien {
  final int id;
  final int userId;
  final String namaKlien;
  final String nip;
  final String notlpKlien;
  final String alamatKlien;
  final String email;

  DataKlien({
    required this.id,
    required this.userId,
    required this.namaKlien,
    required this.nip,
    required this.notlpKlien,
    required this.alamatKlien,
    required this.email,
  });

  factory DataKlien.fromRawJson(String str) =>
      DataKlien.fromJson(json.decode(str));

  factory DataKlien.fromJson(Map<String, dynamic> json) => DataKlien(
        id: json["id_klien"] ?? 0,
        userId: json["user_id"] ?? 0,
        namaKlien: json["nama_klien"] ?? "",
        nip: json["nip"] ?? "",
        notlpKlien: json["notlp_klien"] ?? "",
        alamatKlien: json["alamat_klien"] ?? "",
        email: json["user"]?["email"] ?? "",
      );
}