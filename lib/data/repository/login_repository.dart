import 'dart:convert';
import 'dart:developer';

import 'package:damagereports/data/model/request/auth/login_request_model.dart';
import 'package:damagereports/data/model/response/auth_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:damagereports/data/repository/fcm_repository.dart';

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "login",
        requestModel.toJson(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final loginResponse = AuthResponseModel.fromJson(jsonResponse);
        await secureStorage.write(
          key: "authToken",
          value: loginResponse.user.token,
        );
        await secureStorage.write(
          key: "userRole",
          value: loginResponse.user.role,
        );

        final fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          await FcmRepository(ServiceHttpClient()).saveToken(fcmToken);
        }

        if (fcmToken != null) {
          await FcmRepository(ServiceHttpClient()).saveToken(fcmToken);

          log("FCM Token berhasil dikirim");
        }

        log("Login successful: ${loginResponse.message}");
        return Right(loginResponse);
      } else {
        log("Login failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      log("Error in login: $e");
      return Left("An error occurred while logging in.");
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await secureStorage.read(key: "authToken");
    if (token == null || token.isEmpty) return false;

    try {
      final response = await _serviceHttpClient.get("me");

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        await secureStorage.delete(key: "authToken");
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await secureStorage.read(key: "authToken");

      if (token != null && token.isNotEmpty) {
        await _serviceHttpClient.postWithTokenOnly(
          endPoint: "logout",
        );
      }

      await secureStorage.delete(key: "authToken");
      await secureStorage.delete(key: "userRole");
      await secureStorage.delete(key: "userId");

      log("Logout berhasil & storage dibersihkan");
    } catch (e, stackTrace) {
      log("Error saat logout: $e", stackTrace: stackTrace);
    }
  }
}