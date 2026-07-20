import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/lokasi/lokasi_request_model.dart';
import 'package:damagereports/data/model/response/lokasi_response_model.dart';
import 'package:damagereports/data/repository/lokasi_repository.dart';
import 'package:meta/meta.dart';

part 'lokasi_event.dart';
part 'lokasi_state.dart';

class LokasiBloc extends Bloc<LokasiEvent, LokasiState> {
  final LokasiRepository lokasiRepository;

  LokasiBloc({required this.lokasiRepository}) : super(LokasiInitial()) {
    on<LokasiRequested>(_onLokasiRequested);
    on<LokasiCreateRequested>(_onLokasiCreateRequested);
    on<LokasiUpdateRequested>(_onLokasiUpdateRequested);
    on<LokasiFiltered>(_onLokasiFiltered);
    on<LokasiDeleted>(_onLokasiDeleted);
    on<LoadLokasiByUserId>(_onLoadLokasiByUserId);
  }

  Future<void> _onLokasiRequested(
    LokasiRequested event,
    Emitter<LokasiState> emit,
  ) async {
    emit(LokasiLoading());

     final result = await lokasiRepository.getAllLokasi(
      idProject: event.idProject,
    );

    result.fold(
      (error) => emit(LokasiFailure(error: error)),
      (data) => emit(LokasiLoaded(listLokasi: data.data)),
    );
  }

  Future<void> _onLokasiCreateRequested(
    LokasiCreateRequested event,
    Emitter<LokasiState> emit,
  ) async {
    final result = await lokasiRepository.createLokasi(event.requestModel);

    await result.fold(
      (error) async {
        emit(LokasiFailure(error: error));
      },
      (message) async {
        emit(LokasiOperationSuccess(message: message));
      },
    );

    final refresh = await lokasiRepository.getAllLokasi();
    refresh.fold(
      (error) => emit(LokasiFailure(error: error)),
      (data) => emit(LokasiLoaded(listLokasi: data.data)),
    );
  }

  Future<void> _onLoadLokasiByUserId(
    LoadLokasiByUserId event,
    Emitter<LokasiState> emit,
  ) async {
    emit(LokasiLoading());

    final result = await lokasiRepository.getLokasiByUserId(event.userId);

    result.fold(
      (error) => emit(LokasiFailure(error: error)),
      (lokasiList) => emit(LokasiLoadedState(lokasiList: lokasiList)),
    );
  }

  Future<void> _onLokasiFiltered(
    LokasiFiltered event,
    Emitter<LokasiState> emit,
  ) async {
    if (event.query.isEmpty) {
      final result = await lokasiRepository.getAllLokasi();
      result.fold(
        (failure) => emit(LokasiFailure(error: failure)),
        (data) => emit(LokasiLoaded(listLokasi: data.data)),
      );
      return;
    }
    if (state is LokasiLoaded) {
      final currentState = state as LokasiLoaded;

      final filtered = currentState.listLokasi.where((lokasi) {
        final nama = lokasi.namaLokasi.toLowerCase();
        final input = event.query.toLowerCase();
        return nama.contains(input);
      }).toList();

      emit(LokasiLoaded(listLokasi: filtered));
    }
  }
  
  Future<void> _onLokasiUpdateRequested(
    LokasiUpdateRequested event,
    Emitter<LokasiState> emit,
  ) async {
    final result = await lokasiRepository.updateLokasi(
      event.id,
      event.requestModel,
    );

    await result.fold(
      (error) async => emit(LokasiFailure(error: error)),
      (message) async => emit(LokasiOperationSuccess(message: message)),
    );

    final refresh = await lokasiRepository.getAllLokasi();
    refresh.fold(
      (error) => emit(LokasiFailure(error: error)),
      (data) => emit(LokasiLoaded(listLokasi: data.data)),
    );
  }

  Future<void> _onLokasiDeleted(
    LokasiDeleted event,
    Emitter<LokasiState> emit,
  ) async {
    final result = await lokasiRepository.deleteLokasi(event.id);

    await result.fold(
      (error) async => emit(LokasiDeleteFailure(error: error)),
      (message) async => emit(LokasiOperationSuccess(message: message)),
    );

    final refresh = await lokasiRepository.getAllLokasi();
    refresh.fold(
      (error) => emit(LokasiDeleteFailure(error: error)),
      (data) => emit(LokasiLoaded(listLokasi: data.data)),
    );
  }
}


