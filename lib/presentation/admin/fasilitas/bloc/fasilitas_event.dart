part of 'fasilitas_bloc.dart';


sealed class FasilitasEvent {}

final class FasilitasRequested extends FasilitasEvent {
   final int? idProject;
   FasilitasRequested({
    this.idProject,
  });
}

final class FasilitasCreateRequested extends FasilitasEvent {
  final FasilitasRequestModel requestModel;

  FasilitasCreateRequested({required this.requestModel});
}

final class FasilitasUpdateRequested extends FasilitasEvent {
  final int id;
  final FasilitasRequestModel requestModel;

  FasilitasUpdateRequested({
    required this.id,
    required this.requestModel,
  });
}

final class FasilitasDeleted extends FasilitasEvent {
  final int id;

  FasilitasDeleted(this.id);
}

class LoadFasilitasByUserId extends FasilitasEvent {
  final int userId;
  LoadFasilitasByUserId({required this.userId});
}

final class FasilitasFiltered extends FasilitasEvent {
  final String query;
  FasilitasFiltered(this.query);
}
