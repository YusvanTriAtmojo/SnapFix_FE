import 'package:damagereports/data/model/response/roleakses_response_model.dart';
import 'package:damagereports/presentation/admin/roleakses/bloc/roleakses_bloc.dart';
import 'package:damagereports/presentation/admin/roleakses/roleakses_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleaksesScreen extends StatefulWidget {
  const RoleaksesScreen({super.key});

  @override
  State<RoleaksesScreen> createState() => _RoleaksesScreenState();
}

class _RoleaksesScreenState extends State<RoleaksesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoleaksesBloc>().add(RoleaksesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF003C97), Color(0xFF0056D6)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -30,
                    child: Container(
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Positioned(
                    right: -60,
                    bottom: -60,
                    child: Container(
                      width: 150,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF7A00),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Center(
                    child: Text(
                      "Akses Pengguna",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7A8FB1), Color(0xFFE7EBFF)],
                  ),
                ),
                child: SafeArea(
                  child: BlocConsumer<RoleaksesBloc, RoleaksesState>(
                    listener: (context, state) {
                      if (state is RoleaksesFailure) {
                        if (state.error.toLowerCase().contains("hapus")) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: const EdgeInsets.all(24),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFEBEE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Terjadi Kesalahan",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.error,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else if (state is RoleaksesOperationSuccess) {
                        if (state.message.toLowerCase().contains("hapus")) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: const EdgeInsets.all(24),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF4CD991),
                                        size: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Berhasil",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF4CD991),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is RoleaksesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF003D7A),
                          ),
                        );
                      } else if (state is RoleaksesFailure) {
                        return Center(
                          child: Text('Gagal memuat data: ${state.error}'),
                        );
                      } else if (state is RoleaksesLoaded) {
                        final List<DataRoleAkses> roleaksesList =
                            state.listRoleakses;
                        if (roleaksesList.isEmpty) {
                          return const Center(
                            child: Text("Roleakses belum tersedia"),
                          );
                        }
                        // Daftar Kategori
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: roleaksesList.length,
                          itemBuilder: (context, index) {
                            final role = roleaksesList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF003C97,
                                  ).withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            role.namaRole,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          ...role.akses.map(
                                            (akses) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    akses.namaAkses,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: IconButton(
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      BlocProvider.value(
                                                        value:
                                                            context
                                                                .read<
                                                                  RoleaksesBloc
                                                                >(),
                                                        child:
                                                            RoleaksesEditScreen(
                                                              roleakses: role,
                                                            ),
                                                      ),
                                            ),
                                          );

                                          if (!context.mounted) return;

                                          if (result == true) {
                                            context.read<RoleaksesBloc>().add(
                                              RoleaksesRequested(),
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF0056D6,
                                          ),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
