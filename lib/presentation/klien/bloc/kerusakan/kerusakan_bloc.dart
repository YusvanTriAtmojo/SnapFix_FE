import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/request/kerusakan/kerusakan_request_model.dart';
import 'package:damagereports/data/model/response/kerusakan_response_model.dart';
import 'package:damagereports/data/repository/kerusakan_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'kerusakan_event.dart';
part 'kerusakan_state.dart';

class KerusakanKlienBloc extends Bloc<KerusakanEvent, KerusakanState> {
  final KerusakanRepository kerusakanKlienRepository;

  KerusakanKlienBloc({required this.kerusakanKlienRepository}) : super(KerusakanInitial()) {
    on<KerusakanRequested>(_onKerusakanRequested);
    on<KerusakanCreateRequested>(_onKerusakanCreateRequested);
    on<HapusKerusakanEvent>(_onHapusKerusakan);
  }

  Future<void> _onKerusakanRequested(
    KerusakanRequested event,
    Emitter<KerusakanState> emit,
  ) async {
    emit(KerusakanLoading());

    final Either<String, KerusakanModel> result =
      await kerusakanKlienRepository.getAllKerusakan(
      status: event.status,
      startDate: event.startDate, 
      endDate: event.endDate,    
    );

    result.fold(
      (failure) => emit(KerusakanFailure(error: failure)),
      (data) => emit(KerusakanLoaded(listKerusakan: data.data)),
    );
  }


  Future<void> _onKerusakanCreateRequested(
    KerusakanCreateRequested event,
    Emitter<KerusakanState> emit,
  ) async {
    emit(KerusakanLoading());

    final result = await kerusakanKlienRepository.createKerusakan(event.requestModel);

    result.fold(
      (failure) => emit(KerusakanFailure(error: failure)),
      (message) => emit(KerusakanOperationSuccess(message: message)),
    );
  }


  Future<void> _onHapusKerusakan(
    HapusKerusakanEvent event,
    Emitter<KerusakanState> emit,
  ) async {
    emit(KerusakanLoading());
    final result = await kerusakanKlienRepository.deleteKerusakan(event.id);
    result.fold(
      (failure) => emit(KerusakanFailure(error: failure)),
      (message) => emit(KerusakanOperationSuccess(message: message)),
    );
  }
}
