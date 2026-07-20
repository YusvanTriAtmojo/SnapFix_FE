part of 'lokasi_bloc.dart';

sealed class LokasiState {}

final class LokasiInitial extends LokasiState {}

final class LokasiLoading extends LokasiState {}

final class LokasiLoaded extends LokasiState {
  final List<DataLokasi> listLokasi;

  LokasiLoaded({required this.listLokasi});
}

final class LokasiOperationSuccess extends LokasiState {
  final String message;

  LokasiOperationSuccess({required this.message});
}

final class LokasiFailure extends LokasiState {
  final String error;
  LokasiFailure({required this.error});
}

final class LokasiFiltered extends LokasiEvent {
  final String query;
  LokasiFiltered(this.query);
}


class LokasiLoadedState extends LokasiState {
  final List<DataLokasi> lokasiList;
  LokasiLoadedState({required this.lokasiList});
}

class LokasiDeleteFailure extends LokasiState {
  final String error;

  LokasiDeleteFailure({required this.error});
}


