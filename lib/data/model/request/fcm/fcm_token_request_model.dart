import 'dart:convert';

class FcmTokenRequestModel {
  final String token;

  FcmTokenRequestModel({
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
    };
  }

  String toJson() => jsonEncode(toMap());
}