class RoleAksesRequestModel {
  final List<int> idAkses;

  RoleAksesRequestModel({
    required this.idAkses,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_akses": idAkses,
    };
  }
}