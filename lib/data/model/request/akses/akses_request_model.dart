import 'dart:convert';

class AksesRequestModel {
  final String namaAkses;

  AksesRequestModel({
    required this.namaAkses,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "nama_akses": namaAkses,
      };
}