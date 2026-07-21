part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final List<DataAdminUser> listUser;

  UserLoaded({required this.listUser});
}

final class UserOperationSuccess extends UserState {
  final String message;

  UserOperationSuccess({required this.message});
}

final class UserFailure extends UserState {
  final String error;
  UserFailure({required this.error});
}

final class UserFiltered extends UserEvent {
  final String query;
  UserFiltered(this.query);
}

