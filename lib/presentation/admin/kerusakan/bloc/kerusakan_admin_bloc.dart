import 'package:bloc/bloc.dart';
import 'package:damagereports/data/model/response/kerusakan_admin_response_model.dart';
import 'package:damagereports/data/repository/kerusakan_admin_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'kerusakan_admin_event.dart';
part 'kerusakan_admin_state.dart';

class KerusakanAdminBloc extends Bloc<KerusakanAdminEvent, KerusakanAdminState> {
  final KerusakanAdminRepository kerusakanRepository;

  KerusakanAdminBloc({required this.kerusakanRepository}) : super(KerusakanAdminInitial()) {
    on<KerusakanAdminRequested>(_onKerusakanRequested);
    on<KerusakanAdminDeleted>(_onHapusKerusakan);
  }

  Future<void> _onKerusakanRequested(
    KerusakanAdminRequested event,
    Emitter<KerusakanAdminState> emit,
  ) async {
    emit(KerusakanAdminLoading());

    final Either<String, KerusakanAdminModel> result =
        await kerusakanRepository.getAllKerusakan(
      status: event.status,
      startDate: event.startDate,
      endDate: event.endDate,
      idProject: event.idProject,
    );

    result.fold(
      (failure) => emit(KerusakanAdminFailure(error: failure)),
      (data) => emit(
        KerusakanAdminLoaded(
          listKerusakanAdmin: data.data,
          totalKerusakan: data.totalKerusakan,
          totalPerbaikan: data.totalPerbaikan,
          totalSelesai: data.totalSelesai,
        ),
      ),
    );
  }

  Future<void> _onHapusKerusakan(
    KerusakanAdminDeleted event,
    Emitter<KerusakanAdminState> emit,
  ) async {
    emit(KerusakanAdminLoading());
    final result = await kerusakanRepository.deleteKerusakan(event.id);
    result.fold(
      (failure) => emit(KerusakanAdminFailure(error: failure)),
      (message) => emit(KerusakanAdminOperationSuccess(message: message)),
    );
  }
}

