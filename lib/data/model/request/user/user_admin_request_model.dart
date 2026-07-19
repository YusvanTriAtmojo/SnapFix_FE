import 'dart:convert';

class UserAdminRequestModel {
  final int? idProject;
  final int? idRole;
  final String? name;
  final String? nip;
  final String? notlp;
  final String? alamat;
  final String? email;
  final String? password;

  UserAdminRequestModel({
    this.idProject,
    this.idRole,
    this.name,
    this.nip,
    this.notlp,
    this.alamat,
    this.email,
    this.password,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_project": idProject,
        "id_role": idRole,
        "name": name,
        "nip": nip,
        "notlp": notlp,
        "alamat": alamat,
        "email": email,
        "password": password,
      };
}