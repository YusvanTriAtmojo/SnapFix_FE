import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/request/project/project_request_model.dart';
import 'package:damagereports/data/model/response/project_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class ProjectRepository {
  final ServiceHttpClient httpClient;

  ProjectRepository(this.httpClient);

  Future<Either<String, ProjectResponseModel>> getAllProject() async {
    try {
      final response = await httpClient.get("project");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final projectResponse =
            ProjectResponseModel.fromJson(jsonResponse);

        return Right(projectResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> createProject(
    ProjectRequestModel request,
  ) async {
    try {
      final response = await httpClient.postWithTokenData(
        "project",
        request.toJson(),
      );

      if (response.statusCode == 201) {
        return const Right("Project berhasil ditambahkan");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal menambahkan project',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> updateProject(
    int id,
    ProjectRequestModel request,
  ) async {
    try {
      final response = await httpClient.put(
        "project/$id",
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return const Right("Project berhasil diubah");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal mengubah project',
        );
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Either<String, String>> deleteProject(int id) async {
    try {
      final response = await httpClient.delete(
        "project/$id",
      );

      if (response.statusCode == 200) {
        return const Right("Project berhasil dihapus");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(
          errorMessage['message'] ?? 'Gagal menghapus project',
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