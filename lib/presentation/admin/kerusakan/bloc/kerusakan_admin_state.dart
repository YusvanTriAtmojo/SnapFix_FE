part of 'kerusakan_admin_bloc.dart';

@immutable
sealed class KerusakanAdminState {}

final class KerusakanAdminInitial extends KerusakanAdminState {}

final class KerusakanAdminLoading extends KerusakanAdminState {}

class KerusakanAdminLoaded extends KerusakanAdminState {
  final List<KerusakanAdmin> listKerusakanAdmin;
  final int? totalKerusakan;
  final int? totalPerbaikan;
  final int? totalSelesai;

  KerusakanAdminLoaded({
    required this.listKerusakanAdmin,
    this.totalKerusakan,
    this.totalPerbaikan,
    this.totalSelesai,
  });
}

final class KerusakanAdminOperationSuccess extends KerusakanAdminState {
  final String message;

  KerusakanAdminOperationSuccess({required this.message});
}

final class KerusakanAdminFailure extends KerusakanAdminState {
  final String error;
  KerusakanAdminFailure({required this.error});
}

