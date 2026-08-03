part of 'kerusakan_bloc.dart';

sealed class KerusakanEvent {}

final class KerusakanRequested extends KerusakanEvent {
  final String? status; 
  final DateTime? tanggal;
  final DateTime? startDate;
  final DateTime? endDate;

  KerusakanRequested({this.status, this.tanggal, this.startDate,
    this.endDate,});
}

final class KerusakanCreateRequested extends KerusakanEvent {
  final KerusakanRequestModel requestModel;

  KerusakanCreateRequested({required this.requestModel});
}

class PerbaikanCreateRequested extends KerusakanEvent {
  final int kerusakanId;
  final String tanggalPerbaikan;
  final String deskripsiPerbaikan;
  final String fotoPerbaikanPath;

  PerbaikanCreateRequested({
    required this.kerusakanId,
    required this.tanggalPerbaikan,
    required this.deskripsiPerbaikan,
    required this.fotoPerbaikanPath,
  });
}

class UpdateStatusKerusakanEvent extends KerusakanEvent {
  final int id;
  final String status;

  UpdateStatusKerusakanEvent({
    required this.id,
    required this.status,
  });
}

final class UploadFotoKerusakanRequested extends KerusakanEvent {
  final File imageFile;
  UploadFotoKerusakanRequested(this.imageFile);
}


final class HapusKerusakanEvent extends KerusakanEvent {
  final int id;

  HapusKerusakanEvent(this.id);
}

final class AmbilKerusakanAktifEvent extends KerusakanEvent {}