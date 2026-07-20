part of 'lokasi_bloc.dart';

sealed class LokasiEvent {}

final class LokasiRequested extends LokasiEvent {
     final int? idProject;
   LokasiRequested({
    this.idProject,
  });
}

class LoadLokasiByUserId extends LokasiEvent {
  final int userId;
  LoadLokasiByUserId({required this.userId});
}

final class LokasiCreateRequested extends LokasiEvent {
  final LokasiRequestModel requestModel;

  LokasiCreateRequested({required this.requestModel});
}

final class LokasiUpdateRequested extends LokasiEvent {
  final int id;
  final LokasiRequestModel requestModel;

  LokasiUpdateRequested({
    required this.id,
    required this.requestModel,
  });
}

final class LokasiDeleted extends LokasiEvent {
  final int id;

  LokasiDeleted(this.id);
}


