part of 'roleakses_bloc.dart';

sealed class RoleaksesEvent {}

final class RoleaksesRequested extends RoleaksesEvent {}

final class RoleaksesUpdateRequested extends RoleaksesEvent {
  final int id;
  final RoleAksesRequestModel requestModel;

  RoleaksesUpdateRequested({
    required this.id,
    required this.requestModel,
  });
}



