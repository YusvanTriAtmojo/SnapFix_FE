part of 'akses_bloc.dart';

sealed class AksesEvent {}

final class AksesRequested extends AksesEvent {}

final class AksesCreateRequested extends AksesEvent {
  final AksesRequestModel requestModel;

  AksesCreateRequested({required this.requestModel});
}

final class AksesUpdateRequested extends AksesEvent {
  final int id;
  final AksesRequestModel requestModel;

  AksesUpdateRequested({
    required this.id,
    required this.requestModel,
  });
}

final class AksesDeleted extends AksesEvent {
  final int id;

  AksesDeleted(this.id);
}
