import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/request/fasilitas/fasilitas_request_model.dart';
import 'package:damagereports/data/model/response/fasilitas_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class FasilitasRepository {
  final ServiceHttpClient httpClient;

  FasilitasRepository(this.httpClient);

  Future<Either<String, FasilitasResponseModel>> getAllFasilitas({
    int? idProject,
  }) async {
    try {
      String url = "fasilitas";

      if (idProject != null) {
        url += "?id_project=$idProject";
      }

      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userResponse = FasilitasResponseModel.fromJson(jsonResponse);

        return Right(userResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, List<DataFasilitas>>> getFasilitasByUserId(int userId) async {
    try {
      final response = await httpClient.get("fasilitas/$userId");

      if (response.statusCode != 200) {
        final err = json.decode(response.body);
        return Left(err['message'] ?? "Gagal ambil data fasilitas");
      }

      final jsonResponse = json.decode(response.body);
      final fasilitasJson = jsonResponse['data'] as List;
      final fasilitasList = fasilitasJson.map((e) => DataFasilitas.fromJson(e)).toList();

      return Right(fasilitasList);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> createFasilitas(
    FasilitasRequestModel request,
  ) async {
    try {
      final response = await httpClient.postWithTokenData(
        "fasilitas",
        request.toJson(),
      );

      if (response.statusCode == 201) {
        return const Right("Fasilitas berhasil ditambahkan");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal menambahkan fasilitas',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> updateFasilitas(
    int id,
    FasilitasRequestModel request,
  ) async {
    try {
      final response = await httpClient.put(
        "fasilitas/$id",
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return const Right("Fasilitas berhasil diubah");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal mengubah fasilitas',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> deleteFasilitas(int id) async {
    try {
      final response = await httpClient.delete(
        "fasilitas/$id",
      );

      if (response.statusCode == 200) {
        return const Right("Fasilitas berhasil dihapus");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal menghapus fasilitas',
        );
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
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