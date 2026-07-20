part of 'fasilitas_bloc.dart';

sealed class FasilitasState {}

final class FasilitasInitial extends FasilitasState {}

final class FasilitasLoading extends FasilitasState {}

final class FasilitasLoaded extends FasilitasState {
  final List<DataFasilitas> listFasilitas;

  FasilitasLoaded({required this.listFasilitas});
}

final class FasilitasOperationSuccess extends FasilitasState {
  final String message;

  FasilitasOperationSuccess({required this.message});
}

final class FasilitasFailure extends FasilitasState {
  final String error;
  FasilitasFailure({required this.error});
}


class FasilitasLoadedState extends FasilitasState {
  final List<DataFasilitas> fasilitasList;
  FasilitasLoadedState({required this.fasilitasList});
}

class FasilitasDeleteFailure extends FasilitasState {
  final String error;

  FasilitasDeleteFailure({required this.error});
}