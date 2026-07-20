import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/response/akses_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class AksesRepository {
  final ServiceHttpClient httpClient;

  AksesRepository(this.httpClient);

  Future<Either<String, AksesResponseModel>> getAllAkses() async {
    try {
      final response = await httpClient.get("akses");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final aksesResponse =
            AksesResponseModel.fromJson(jsonResponse);

        return Right(aksesResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
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