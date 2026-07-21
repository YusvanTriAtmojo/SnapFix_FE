import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/user/user_admin_request_model.dart';
import 'package:damagereports/data/model/response/user_all_response_model.dart';
import 'package:damagereports/data/repository/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<UserRequested>(_onUserRequested);
    on<UserCreateRequested>(_onUserCreateRequested);
    on<UserUpdateRequested>(_onUserUpdateRequested);
    on<UserFiltered>(_onUserFiltered);
    on<UserDeleted>(_onUserDeleted);
  }

  Future<void> _onUserRequested(
    UserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    final result = await userRepository.getAllUser(
      idProject: event.idProject,
    );

    result.fold(
      (error) => emit(UserFailure(error: error)),
      (data) => emit(UserLoaded(listUser: data.data)),
    );
  }

  Future<void> _onUserCreateRequested(
    UserCreateRequested event,
    Emitter<UserState> emit,
  ) async {
    final result = await userRepository.createUser(event.requestModel);

    await result.fold(
      (error) async {
        emit(UserFailure(error: error));
      },
      (message) async {
        emit(UserOperationSuccess(message: message));
      },
    );

    final refresh = await userRepository.getAllUser();
    refresh.fold(
      (error) => emit(UserFailure(error: error)),
      (data) => emit(UserLoaded(listUser: data.data)),
    );
  }

  Future<void> _onUserUpdateRequested(
    UserUpdateRequested event,
    Emitter<UserState> emit,
  ) async {
    final result = await userRepository.updateUser(
      event.id,
      event.requestModel,
    );

    await result.fold(
      (error) async => emit(UserFailure(error: error)),
      (message) async => emit(UserOperationSuccess(message: message)),
    );

    final refresh = await userRepository.getAllUser();
    refresh.fold(
      (error) => emit(UserFailure(error: error)),
      (data) => emit(UserLoaded(listUser: data.data)),
    );
  }

  Future<void> _onUserFiltered(
    UserFiltered event,
    Emitter<UserState> emit,
  ) async {
    if (event.query.isEmpty) {
      final result = await userRepository.getAllUser();
      result.fold(
        (failure) => emit(UserFailure(error: failure)),
        (data) => emit(UserLoaded(listUser: data.data)),
      );
      return;
    }
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      final filtered = currentState.listUser.where((user) {
        final nama = user.name.toLowerCase();
        final input = event.query.toLowerCase();
        return nama.contains(input);
      }).toList();

      emit(UserLoaded(listUser: filtered));
    }
  }

  Future<void> _onUserDeleted(
    UserDeleted event,
    Emitter<UserState> emit,
  ) async {
    final result = await userRepository.deleteUser(event.id);

    await result.fold(
      (error) async => emit(UserFailure(error: error)),
      (message) async => emit(UserOperationSuccess(message: message)),
    );

    final refresh = await userRepository.getAllUser();
    refresh.fold(
      (error) => emit(UserFailure(error: error)),
      (data) => emit(UserLoaded(listUser: data.data)),
    );
  }
}


