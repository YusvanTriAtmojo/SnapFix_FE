import 'dart:convert';

class KerusakanRequestModel {
  final int? userId;
  final int? projectId;
  final int? lokasiId;
  final int? fasilitasId;
  final String tanggal;
  final double latPosisi;
  final double lngPosisi;
  final String deskripsi;
  final String? fotoKerusakan;
  final String status;

  KerusakanRequestModel({
    this.userId,
    this.projectId,
    this.lokasiId,
    this.fasilitasId,
    required this.tanggal,
    required this.latPosisi,
    required this.lngPosisi,
    required this.deskripsi,
    this.fotoKerusakan,
    this.status = 'pending',
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "id_project": projectId,
        "id_lokasi": lokasiId,
        "id_fasilitas": fasilitasId,
        "tanggal": tanggal,
        "lat_posisi": latPosisi,
        "lng_posisi": lngPosisi,
        "deskripsi": deskripsi,
        "foto_kerusakan": fotoKerusakan,
        "status": status,
      };
}