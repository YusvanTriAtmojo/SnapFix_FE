import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/request/roleakses/roleakses_request_model.dart';
import 'package:damagereports/data/model/response/roleakses_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class RoleAksesRepository {
  final ServiceHttpClient httpClient;

  RoleAksesRepository(this.httpClient);

  Future<Either<String, RoleAksesResponseModel>>
      getAllRoleAkses() async {
    try {
      final response = await httpClient.get("roleakses");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final roleAksesResponse =
            RoleAksesResponseModel.fromJson(jsonResponse);

        return Right(roleAksesResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> updateRoleAkses(
    int id,
    RoleAksesRequestModel request,
  ) async {
    try {
      final response = await httpClient.put(
        "roleakses/$id",
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return const Right("Role Akses berhasil diubah");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ??
              'Gagal mengubah Role Akses',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Either<String, T> _handleError<T>(Object e) {
    if (e is SocketException) {
      return const Left("Tidak ada koneksi internet");
    } else if (e is HttpException) {
      return Left("Kesalahan HTTP: ${e.message}");
    } else if (e is FormatException) {
      return const Left("Format respons tidak valid");
    } else {
      return Left("Terjadi kesalahan tak terduga: $e");
    }
  }
}