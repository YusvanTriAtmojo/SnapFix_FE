import 'dart:convert';

import 'package:damagereports/service/service_http_client.dart';

class FcmRepository {
  final ServiceHttpClient serviceHttpClient;

  FcmRepository(this.serviceHttpClient);

  Future<void> saveToken(String token) async {
    final response = await serviceHttpClient.postWithTokenOnly(
      endPoint: "fcm-token",
      fields: {
        "token": token,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }
}