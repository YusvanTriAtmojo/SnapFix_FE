import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/request/lokasi/lokasi_request_model.dart';
import 'package:damagereports/data/model/response/lokasi_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class LokasiRepository {
  final ServiceHttpClient httpClient;

  LokasiRepository(this.httpClient);

   Future<Either<String, LokasiResponseModel>> getAllLokasi({
    int? idProject,
  }) async {
    try {
      String url = "lokasi";

      if (idProject != null) {
        url += "?id_project=$idProject";
      }

      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userResponse = LokasiResponseModel.fromJson(jsonResponse);

        return Right(userResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> createLokasi(
    LokasiRequestModel request,
  ) async {
    try {
      final response = await httpClient.postWithTokenData(
        "lokasi",
        request.toJson(),
      );

      if (response.statusCode == 201) {
        return const Right("Lokasi berhasil ditambahkan");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal menambahkan lokasi',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> updateLokasi(
    int id,
    LokasiRequestModel request,
  ) async {
    try {
      final response = await httpClient.put(
        "lokasi/$id",
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return const Right("Lokasi berhasil diubah");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal mengubah lokasi',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> deleteLokasi(int id) async {
    try {
      final response = await httpClient.delete(
        "lokasi/$id",
      );

      if (response.statusCode == 200) {
        return const Right("Lokasi berhasil dihapus");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal menghapus lokasi',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, List<DataLokasi>>> getLokasiByUserId(int userId) async {
    try {
      final response = await httpClient.get("lokasi/$userId");

      if (response.statusCode != 200) {
        final err = json.decode(response.body);
        return Left(err['message'] ?? "Gagal ambil data lokasi");
      }

      final jsonResponse = json.decode(response.body);
      final lokasiJson = jsonResponse['data'] as List;
      final lokasiList = lokasiJson.map((e) => DataLokasi.fromJson(e)).toList();

      return Right(lokasiList);
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