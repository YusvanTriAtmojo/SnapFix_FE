import 'dart:convert';

class UserRequestModel {
  final String? name;
  final String? nip;
  final String? email;
  final String? notlp;
  final String? alamat;

  UserRequestModel({
    this.name,
    this.nip,
    this.email,
    this.notlp,
    this.alamat,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "name": name,
        "nip": nip,
        "email": email,
        "notlp": notlp,
        "alamat": alamat,
      };
}