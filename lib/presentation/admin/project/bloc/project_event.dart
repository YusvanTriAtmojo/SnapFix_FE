part of 'project_bloc.dart';

sealed class ProjectEvent {}

final class ProjectRequested extends ProjectEvent {}

final class ProjectCreateRequested extends ProjectEvent {
  final ProjectRequestModel requestModel;

  ProjectCreateRequested({required this.requestModel});
}

final class ProjectUpdateRequested extends ProjectEvent {
  final int id;
  final ProjectRequestModel requestModel;

  ProjectUpdateRequested({
    required this.id,
    required this.requestModel,
  });
}

final class ProjectDeleted extends ProjectEvent {
  final int id;

  ProjectDeleted(this.id);
}

