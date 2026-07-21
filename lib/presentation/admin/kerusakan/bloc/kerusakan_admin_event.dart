part of 'kerusakan_admin_bloc.dart';

@immutable
sealed class KerusakanAdminEvent {}

final class KerusakanAdminRequested extends KerusakanAdminEvent {
  final String? status; 
  final DateTime? tanggal;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? idProject;

  KerusakanAdminRequested({this.status, this.tanggal, this.startDate,
    this.endDate, this.idProject,});
}

final class KerusakanAdminDeleted extends KerusakanAdminEvent {
  final int id;

  KerusakanAdminDeleted(this.id);
}
