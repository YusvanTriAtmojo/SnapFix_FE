import 'dart:convert';

class KerusakanModel {
  final String message;
  final int statusCode;
  final List<Kerusakan> data;

  KerusakanModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory KerusakanModel.fromRawJson(String str) =>
      KerusakanModel.fromJson(json.decode(str));

  factory KerusakanModel.fromJson(Map<String, dynamic> json) =>
      KerusakanModel(
        message: json["message"] ?? "",
        statusCode: json["status_code"] ?? 0,
        data: List<Kerusakan>.from(
          (json["data"] ?? []).map(
            (x) => Kerusakan.fromJson(x),
          ),
        ),
      );
}

class Kerusakan {
  final int idKerusakan;
  final int? userId;
  final int? projectId;
  final int? lokasiId;
  final int? fasilitasId;
  final String? tanggal;
  final String? tanggalPerbaikan;
  final double latPosisi;
  final double lngPosisi;
  final String deskripsi;
  final String? fotoKerusakan;
  final String? fotoPerbaikan;
  final String status;
  final String? user;
  final String? role;
  final String? lokasi;
  final String? fasilitas;

  Kerusakan({
    required this.idKerusakan,
    this.userId,
    this.projectId,
    this.lokasiId,
    this.fasilitasId,
    this.tanggal,
    this.tanggalPerbaikan,
    required this.latPosisi,
    required this.lngPosisi,
    required this.deskripsi,
    this.fotoKerusakan,
    this.fotoPerbaikan,
    required this.status,
    this.user,
    this.role,
    this.lokasi,
    this.fasilitas,
  });

  factory Kerusakan.fromRawJson(String str) =>
      Kerusakan.fromJson(json.decode(str));

  factory Kerusakan.fromJson(Map<String, dynamic> json) => Kerusakan(
        idKerusakan: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        userId: json["user_id"] is int
            ? json["user_id"]
            : int.tryParse(json["user_id"]?.toString() ?? ''),
        projectId: json["id_project"] is int
            ? json["id_project"]
            : int.tryParse(json["id_project"]?.toString() ?? ''),
        lokasiId: json["id_lokasi"] is int
            ? json["id_lokasi"]
            : int.tryParse(json["id_lokasi"]?.toString() ?? ''),
        fasilitasId: json["id_fasilitas"] is int
            ? json["id_fasilitas"]
            : int.tryParse(json["id_fasilitas"]?.toString() ?? ''),
        tanggal: json["tanggal"],
        tanggalPerbaikan: json["tanggal_perbaikan"],
        latPosisi: json["lat_posisi"] != null
            ? double.tryParse(json["lat_posisi"].toString()) ?? 0.0
            : 0.0,
        lngPosisi: json["lng_posisi"] != null
            ? double.tryParse(json["lng_posisi"].toString()) ?? 0.0
            : 0.0,
        deskripsi: json["deskripsi"] ?? '',
        fotoKerusakan: json["foto_kerusakan"],
        fotoPerbaikan: json["foto_perbaikan"],
        status: json["status"] ?? '',
        user: json["user"]?.toString(),
        role: json["role"]?.toString(),
        lokasi: json["lokasi"]?.toString(),
        fasilitas: json["fasilitas"]?.toString(),
      );
}