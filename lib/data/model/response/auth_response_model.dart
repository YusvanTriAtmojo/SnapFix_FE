import 'dart:convert';

class AuthResponseModel {
  final String message;
  final int statusCode;
  final User user;

  AuthResponseModel({
    required this.message,
    required this.statusCode,
    required this.user,
  });

  factory AuthResponseModel.fromRawJson(String str) =>
      AuthResponseModel.fromJson(json.decode(str));

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        message: json["message"] ?? "",
        statusCode: json["status_code"] ?? 0,
        user: User.fromJson(json["data"]),
      );
}

class User {
  final int id;
  final String name;
  final String nip;
  final String notlp;
  final String alamat;
  final String email;
  final String token;
  final String role;
  final List<String> akses;

  User({
    required this.id,
    required this.name,
    required this.nip,
    required this.notlp,
    required this.alamat,
    required this.email,
    required this.token,
    required this.role,
    required this.akses,
  });

  factory User.fromRawJson(String str) =>
      User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        nip: json["nip"] ?? "",
        notlp: json["notlp"] ?? "",
        alamat: json["alamat"] ?? "",
        email: json["email"] ?? "",
        token: json["token"] ?? "",
        role: json["role"] ?? "",
        akses: (json["akses"] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
}