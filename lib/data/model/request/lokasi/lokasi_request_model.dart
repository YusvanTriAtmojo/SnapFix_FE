import 'dart:convert';

class LokasiRequestModel {
  final int? idProject;
  final String namaLokasi;

  LokasiRequestModel({
    this.idProject,
    required this.namaLokasi,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_project": idProject,
        "nama_lokasi": namaLokasi,
      };
}