import 'dart:convert';

class FasilitasRequestModel {
  final int? idProject;
  final String namaFasilitas;

  FasilitasRequestModel({
    this.idProject,
    required this.namaFasilitas,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_project": idProject,
        "nama_fasilitas": namaFasilitas,
      };
}