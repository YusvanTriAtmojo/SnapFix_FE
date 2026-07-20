import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:damagereports/data/model/request/fasilitas/fasilitas_request_model.dart';
import 'package:damagereports/data/model/response/fasilitas_response_model.dart';
import 'package:damagereports/data/repository/fasilitas_repository.dart';

part 'fasilitas_event.dart';
part 'fasilitas_state.dart';

class FasilitasBloc extends Bloc<FasilitasEvent, FasilitasState> {
  final FasilitasRepository fasilitasRepository;

  FasilitasBloc({required this.fasilitasRepository}) : super(FasilitasInitial()) {
    on<FasilitasRequested>(_onFasilitasRequested);
    on<FasilitasCreateRequested>(_onFasilitasCreateRequested);
    on<FasilitasUpdateRequested>(_onFasilitasUpdateRequested);
    on<FasilitasDeleted>(_onFasilitasDeleted);
    on<FasilitasFiltered>(_onFasilitasFiltered);
    on<LoadFasilitasByUserId>(_onLoadFasilitasByUserId);
  }

  Future<void> _onFasilitasRequested(
    FasilitasRequested event,
    Emitter<FasilitasState> emit,
  ) async {
    emit(FasilitasLoading());

     final result = await fasilitasRepository.getAllFasilitas(
      idProject: event.idProject,
    );

    result.fold(
      (error) => emit(FasilitasFailure(error: error)),
      (data) => emit(FasilitasLoaded(listFasilitas: data.data)),
    );
  }

  Future<void> _onFasilitasCreateRequested(
    FasilitasCreateRequested event,
    Emitter<FasilitasState> emit,
  ) async {
    final result = await fasilitasRepository.createFasilitas(event.requestModel);

    await result.fold(
      (error) async {
        emit(FasilitasFailure(error: error));
      },
      (message) async {
        emit(FasilitasOperationSuccess(message: message));
      },
    );

    final refresh = await fasilitasRepository.getAllFasilitas();
    refresh.fold(
      (error) => emit(FasilitasFailure(error: error)),
      (data) => emit(FasilitasLoaded(listFasilitas: data.data)),
    );
  }

  Future<void> _onFasilitasFiltered(
    FasilitasFiltered event,
    Emitter<FasilitasState> emit,
  ) async {
    if (event.query.isEmpty) {
      final result = await fasilitasRepository.getAllFasilitas();
      result.fold(
        (failure) => emit(FasilitasFailure(error: failure)),
        (data) => emit(FasilitasLoaded(listFasilitas: data.data)),
      );
      return;
    }
    if (state is FasilitasLoaded) {
      final currentState = state as FasilitasLoaded;

      final filtered = currentState.listFasilitas.where((fasilitas) {
        final nama = fasilitas.namaFasilitas.toLowerCase();
        final input = event.query.toLowerCase();
        return nama.contains(input);
      }).toList();

      emit(FasilitasLoaded(listFasilitas: filtered));
    }
  }

  Future<void> _onFasilitasUpdateRequested(
    FasilitasUpdateRequested event,
    Emitter<FasilitasState> emit,
  ) async {
    final result = await fasilitasRepository.updateFasilitas(
      event.id,
      event.requestModel,
    );

    await result.fold(
      (error) async => emit(FasilitasFailure(error: error)),
      (message) async => emit(FasilitasOperationSuccess(message: message)),
    );

    final refresh = await fasilitasRepository.getAllFasilitas();
    refresh.fold(
      (error) => emit(FasilitasFailure(error: error)),
      (data) => emit(FasilitasLoaded(listFasilitas: data.data)),
    );
  }

  Future<void> _onFasilitasDeleted(
    FasilitasDeleted event,
    Emitter<FasilitasState> emit,
  ) async {
    final result = await fasilitasRepository.deleteFasilitas(event.id);

    await result.fold(
      (error) async => emit(FasilitasDeleteFailure(error: error)),
      (message) async => emit(FasilitasOperationSuccess(message: message)),
    );

    final refresh = await fasilitasRepository.getAllFasilitas();
    refresh.fold(
      (error) => emit(FasilitasDeleteFailure(error: error)),
      (data) => emit(FasilitasLoaded(listFasilitas: data.data)),
    );
  }

  Future<void> _onLoadFasilitasByUserId(
    LoadFasilitasByUserId event,
    Emitter<FasilitasState> emit,
  ) async {
    emit(FasilitasLoading());

    final result = await fasilitasRepository.getFasilitasByUserId(event.userId);

    result.fold(
      (error) => emit(FasilitasFailure(error: error)),
      (fasilitasList) => emit(FasilitasLoadedState(fasilitasList: fasilitasList)),
    );
  }
}
