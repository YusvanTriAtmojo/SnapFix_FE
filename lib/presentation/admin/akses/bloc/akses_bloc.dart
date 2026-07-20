import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/akses/akses_request_model.dart';
import 'package:damagereports/data/model/response/akses_response_model.dart';
import 'package:damagereports/data/repository/akses_repository.dart';
import 'package:meta/meta.dart';

part 'akses_event.dart';
part 'akses_state.dart';

class AksesBloc extends Bloc<AksesEvent, AksesState> {
  final AksesRepository aksesRepository;

  AksesBloc({required this.aksesRepository}) : super(AksesInitial()) {
    on<AksesRequested>(_onAksesRequested);
  }

  Future<void> _onAksesRequested(
    AksesRequested event,
    Emitter<AksesState> emit,
  ) async {
    emit(AksesLoading());

    final result = await aksesRepository.getAllAkses();

    result.fold(
      (error) => emit(AksesLoadFailure(error: error)),
      (data) => emit(AksesLoaded(listAkses: data.data)),
    );
  }
}