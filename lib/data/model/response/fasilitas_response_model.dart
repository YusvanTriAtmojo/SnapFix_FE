import 'dart:convert';

class FasilitasResponseModel {
  final String message;
  final int statusCode;
  final List<DataFasilitas> data;

  FasilitasResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory FasilitasResponseModel.fromRawJson(String str) =>
      FasilitasResponseModel.fromJson(json.decode(str));

  factory FasilitasResponseModel.fromJson(Map<String, dynamic> json) =>
      FasilitasResponseModel(
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 0,
        data: json["data"] != null
            ? List<DataFasilitas>.from(
                json["data"].map(
                  (x) => DataFasilitas.fromJson(x),
                ),
              )
            : [],
      );
}

class DataFasilitas {
  final int idFasilitas;
  final int idProject;
  final String namaProject;
  final String namaFasilitas;

  DataFasilitas({
    required this.idFasilitas,
    required this.idProject,
    required this.namaProject,
    required this.namaFasilitas,
  });

  factory DataFasilitas.fromRawJson(String str) =>
      DataFasilitas.fromJson(json.decode(str));

  factory DataFasilitas.fromJson(Map<String, dynamic> json) => DataFasilitas(
        idFasilitas: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        idProject: json["id_project"] is int
            ? json["id_project"]
            : int.tryParse(json["id_project"]?.toString() ?? '') ?? 0,
        namaProject: json["nama_project"] ?? '',
        namaFasilitas: json["nama_fasilitas"] ?? '',
      );
}