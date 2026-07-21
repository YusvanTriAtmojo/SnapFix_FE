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


final class UploadFotoKerusakanRequested extends KerusakanEvent {
  final File imageFile;
  UploadFotoKerusakanRequested(this.imageFile);
}

final class KerusakanDeleted extends KerusakanEvent {
  final int id;

  KerusakanDeleted(this.id);
}

final class HapusKerusakanEvent extends KerusakanEvent {
  final int id;

  HapusKerusakanEvent(this.id);
}

final class AmbilKerusakanAktifEvent extends KerusakanEvent {}