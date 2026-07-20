import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/response/role_response_model.dart';
import 'package:damagereports/data/repository/role_repository.dart';
import 'package:meta/meta.dart';

part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final RoleRepository roleRepository;

  RoleBloc({required this.roleRepository}) : super(RoleInitial()) {
    on<RoleRequested>(_onRoleRequested);

  }

  Future<void> _onRoleRequested(
    RoleRequested event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());

    final result = await roleRepository.getAllRole();

    result.fold(
      (error) => emit(RoleFailure(error: error)),
      (data) => emit(RoleLoaded(listRole: data.data)),
    );
  }
}


