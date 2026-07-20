part of 'role_bloc.dart';

@immutable
sealed class RoleState {}

final class RoleInitial extends RoleState {}

final class RoleLoading extends RoleState {}

final class RoleLoaded extends RoleState {
  final List<DataRole> listRole;

  RoleLoaded({required this.listRole});
}

final class RoleOperationSuccess extends RoleState {
  final String message;

  RoleOperationSuccess({required this.message});
}

final class RoleFailure extends RoleState {
  final String error;
  RoleFailure({required this.error});
}

