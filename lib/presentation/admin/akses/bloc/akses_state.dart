part of 'akses_bloc.dart';

sealed class AksesState {}

final class AksesInitial extends AksesState {}

final class AksesLoading extends AksesState {}

final class AksesLoaded extends AksesState {
  final List<DataAkses> listAkses;

  AksesLoaded({required this.listAkses});
}

final class AksesOperationSuccess extends AksesState {
  final String message;

  AksesOperationSuccess({required this.message});
}

final class AksesLoadFailure extends AksesState {
  final String error;
  AksesLoadFailure({required this.error});
}

final class AksesActionFailure extends AksesState {
  final String error;
  AksesActionFailure({required this.error});
}


