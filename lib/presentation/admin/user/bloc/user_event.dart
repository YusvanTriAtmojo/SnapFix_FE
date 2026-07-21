part of 'user_bloc.dart';

sealed class UserEvent {}

final class UserRequested extends UserEvent {
   final int? idProject;
   UserRequested({
    this.idProject,
  });
}

final class UserCreateRequested extends UserEvent {
  final UserAdminRequestModel requestModel;

  UserCreateRequested({required this.requestModel});
}

final class UserUpdateRequested extends UserEvent {
  final int id;
  final UserAdminRequestModel requestModel;

  UserUpdateRequested({
    required this.id,
    required this.requestModel,
  });
}

final class UserDeleted extends UserEvent {
  final int id;

  UserDeleted(this.id);
}


