part of 'roleakses_bloc.dart';

sealed class RoleaksesState {}

final class RoleaksesInitial extends RoleaksesState {}

final class RoleaksesLoading extends RoleaksesState {}

final class RoleaksesLoaded extends RoleaksesState {
  final List<DataRoleAkses> listRoleakses;

  RoleaksesLoaded({required this.listRoleakses});
}

final class RoleaksesOperationSuccess extends RoleaksesState {
  final String message;

  RoleaksesOperationSuccess({required this.message});
}

final class RoleaksesFailure extends RoleaksesState {
  final String error;
  RoleaksesFailure({required this.error});
}



