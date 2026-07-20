import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/response/kerusakan_admin_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class KerusakanAdminRepository {
  final ServiceHttpClient httpClient;

  KerusakanAdminRepository(this.httpClient);

  Future<Either<String, KerusakanAdminModel>> getAllKerusakan({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? idProject,
  }) async {
    try {
      final List<String> queryParams = [];

      String formatDate(DateTime date) =>
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (idProject != null) {
        queryParams.add('id_project=$idProject');
      }

      if (status != null && status.isNotEmpty) {
        queryParams.add('status=$status');
      }

      if (startDate != null) {
        queryParams.add('start_date=${formatDate(startDate)}');
      }

      if (endDate != null) {
        queryParams.add('end_date=${formatDate(endDate)}');
      }

      final queryString =
          queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';

      final response = await httpClient.get("admin$queryString");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Right(KerusakanAdminModel.fromJson(jsonResponse));
      } else {
        final err = json.decode(response.body);
        return Left(err['message'] ?? 'Gagal memuat data kerusakan');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Future<Either<String, String>> deleteKerusakan(int id) async {
    try {
      final response = await httpClient.delete('kerusakan/$id');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final message = jsonResponse['message'] ?? 'Kerusakan berhasil dibatalkan';
        return Right(message);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus kerusakan');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Either<String, T> _infopenyimpangan<T>(Object e) {
    if (e is SocketException) {
      return Left("Tidak ada koneksi internet");
    } else if (e is HttpException) {
      return Left("Kesalahan HTTP: ${e.message}");
    } else if (e is FormatException) {
      return Left("Format respons tidak valid");
    } else {
      return Left("Terjadi kesalahan tak terduga: $e");
    }
  }
}
