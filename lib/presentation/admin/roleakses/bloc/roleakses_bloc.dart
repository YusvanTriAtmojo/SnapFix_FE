import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/roleakses/roleakses_request_model.dart';
import 'package:damagereports/data/model/response/roleakses_response_model.dart';
import 'package:damagereports/data/repository/roleakses_repository.dart';
import 'package:meta/meta.dart';

part 'roleakses_event.dart';
part 'roleakses_state.dart';

class RoleaksesBloc extends Bloc<RoleaksesEvent, RoleaksesState> {
  final RoleAksesRepository roleaksesRepository;

  RoleaksesBloc({required this.roleaksesRepository}) : super(RoleaksesInitial()) {
    on<RoleaksesRequested>(_onRoleaksesRequested);
    on<RoleaksesUpdateRequested>(_onRoleaksesUpdateRequested);
  }

  Future<void> _onRoleaksesRequested(
    RoleaksesRequested event,
    Emitter<RoleaksesState> emit,
  ) async {
    emit(RoleaksesLoading());

    final result = await roleaksesRepository.getAllRoleAkses();

    result.fold(
      (error) => emit(RoleaksesFailure(error: error)),
      (data) => emit(RoleaksesLoaded(listRoleakses: data.data)),
    );
  }


  Future<void> _onRoleaksesUpdateRequested(
    RoleaksesUpdateRequested event,
    Emitter<RoleaksesState> emit,
  ) async {
    final result = await roleaksesRepository.updateRoleAkses(
      event.id,
      event.requestModel,
    );

    await result.fold(
      (error) async => emit(RoleaksesFailure(error: error)),
      (message) async => emit(RoleaksesOperationSuccess(message: message)),
    );

    final refresh = await roleaksesRepository.getAllRoleAkses();
    refresh.fold(
      (error) => emit(RoleaksesFailure(error: error)),
      (data) => emit(RoleaksesLoaded(listRoleakses: data.data)),
    );
  }
}



