import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/project/project_request_model.dart';
import 'package:damagereports/data/model/response/project_response_model.dart';
import 'package:damagereports/data/repository/project_repository.dart';
import 'package:meta/meta.dart';

part 'project_event.dart';
part 'project_state.dart';


class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository projectRepository;

  ProjectBloc({required this.projectRepository}) : super(ProjectInitial()) {
    on<ProjectRequested>(_onProjectRequested);
    on<ProjectCreateRequested>(_onProjectCreateRequested);
    on<ProjectUpdateRequested>(_onProjectUpdateRequested);
    on<ProjectDeleted>(_onProjectDeleted);
  }

  Future<void> _onProjectRequested(
    ProjectRequested event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());

    final result = await projectRepository.getAllProject();

    result.fold(
      (error) => emit(ProjectFailure(error: error)),
      (data) => emit(ProjectLoaded(listProject: data.data)),
    );
  }

  Future<void> _onProjectCreateRequested(
    ProjectCreateRequested event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await projectRepository.createProject(event.requestModel);

    await result.fold(
      (error) async {
        emit(ProjectFailure(error: error));
      },
      (message) async {
        emit(ProjectOperationSuccess(message: message));
      },
    );

    final refresh = await projectRepository.getAllProject();
    refresh.fold(
      (error) => emit(ProjectFailure(error: error)),
      (data) => emit(ProjectLoaded(listProject: data.data)),
    );
  }

  Future<void> _onProjectUpdateRequested(
    ProjectUpdateRequested event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await projectRepository.updateProject(
      event.id,
      event.requestModel,
    );

    await result.fold(
      (error) async => emit(ProjectFailure(error: error)),
      (message) async => emit(ProjectOperationSuccess(message: message)),
    );

    final refresh = await projectRepository.getAllProject();
    refresh.fold(
      (error) => emit(ProjectFailure(error: error)),
      (data) => emit(ProjectLoaded(listProject: data.data)),
    );
  }

  Future<void> _onProjectDeleted(
    ProjectDeleted event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await projectRepository.deleteProject(event.id);

    await result.fold(
      (error) async => emit(ProjectDeleteFailure(error: error)),
      (message) async => emit(ProjectOperationSuccess(message: message)),
    );

    final refresh = await projectRepository.getAllProject();
    refresh.fold(
      (error) => emit(ProjectDeleteFailure(error: error)),
      (data) => emit(ProjectLoaded(listProject: data.data)),
    );
  }
}

