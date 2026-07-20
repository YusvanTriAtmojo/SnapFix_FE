part of 'project_bloc.dart';

sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

final class ProjectLoading extends ProjectState {}

final class ProjectLoaded extends ProjectState {
  final List<DataProject> listProject;

  ProjectLoaded({required this.listProject});
}

final class ProjectOperationSuccess extends ProjectState {
  final String message;

  ProjectOperationSuccess({required this.message});
}

final class ProjectFailure extends ProjectState {
  final String error;
  ProjectFailure({required this.error});
}

class ProjectDeleteFailure extends ProjectState {
  final String error;

  ProjectDeleteFailure({required this.error});
}

