import 'package:damagereports/data/model/response/fasilitas_response_model.dart';
import 'package:damagereports/data/model/response/project_response_model.dart';
import 'package:damagereports/presentation/admin/fasilitas/bloc/fasilitas_bloc.dart';
import 'package:damagereports/presentation/admin/fasilitas/fasilitas_add_screen.dart';
import 'package:damagereports/presentation/admin/fasilitas/fasilitas_edit_screen.dart';
import 'package:damagereports/presentation/admin/project/bloc/project_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FasilitasScreen extends StatefulWidget {
  const FasilitasScreen({super.key});

  @override
  State<FasilitasScreen> createState() => _FasilitasScreenState();
}

class _FasilitasScreenState extends State<FasilitasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedProject = 'Semua';
  @override
  void initState() {
    super.initState();
    context.read<FasilitasBloc>().add(FasilitasRequested());
    context.read<ProjectBloc>().add(ProjectRequested());
    _searchController.addListener(() {
      final query = _searchController.text;

      if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(query)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Fasilitas hanya bisa dicari dengan huruf.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
          ),
        );
        return;
      }
      context.read<FasilitasBloc>().add(FasilitasFiltered(query));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                      "Daftar Fasilitas",
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
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 3,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama Fasilitas',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            BlocBuilder<ProjectBloc, ProjectState>(
                              builder: (context, state) {
                                if (state is ProjectLoaded) {
                                  final List<DataProject> projects =
                                      state.listProject;

                                  final List<DataProject?> projectOptions = [
                                    null, // untuk "Semua"
                                    ...projects,
                                  ];

                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFF003D7A),
                                          width: 1,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children:
                                              projectOptions.asMap().entries.map((
                                                entry,
                                              ) {
                                                final index = entry.key;
                                                final project = entry.value;

                                                final title =
                                                    project == null
                                                        ? "Semua"
                                                        : project.namaProject;

                                                final isSelected =
                                                    selectedProject == title;

                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedProject = title;
                                                    });

                                                    context
                                                        .read<FasilitasBloc>()
                                                        .add(
                                                          FasilitasRequested(
                                                            idProject:
                                                                project
                                                                    ?.idProject,
                                                          ),
                                                        );
                                                  },
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                          minWidth: 90,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isSelected
                                                              ? const Color(
                                                                0xFF002F87,
                                                              )
                                                              : Colors
                                                                  .transparent,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            index == 0
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                        bottomLeft:
                                                            index == 0
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                        topRight:
                                                            index ==
                                                                    projectOptions
                                                                            .length -
                                                                        1
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                        bottomRight:
                                                            index ==
                                                                    projectOptions
                                                                            .length -
                                                                        1
                                                                ? const Radius.circular(
                                                                  12,
                                                                )
                                                                : Radius.zero,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        title,
                                                        style: TextStyle(
                                                          color:
                                                              isSelected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                if (state is ProjectLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF003C97),
                                    ),
                                  );
                                }

                                return const SizedBox();
                              },
                            ),
                            Expanded(
                              child: BlocConsumer<
                                FasilitasBloc,
                                FasilitasState
                              >(
                                listener: (context, state) {
                                  if (state is FasilitasDeleteFailure) {
                                    if (state.error.toLowerCase().contains(
                                      "hapus",
                                    )) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(24),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Color(
                                                          0xFFFFEBEE,
                                                        ),
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
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text(
                                                      "OK",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  } else if (state
                                      is FasilitasOperationSuccess) {
                                    if (state.message.toLowerCase().contains(
                                      "hapus",
                                    )) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(24),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration:
                                                      const BoxDecoration(
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
                                                      backgroundColor: Color(
                                                        0xFF4CD991,
                                                      ),
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text(
                                                      "OK",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  if (state is FasilitasLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF003C97),
                                      ),
                                    );
                                  } else if (state is FasilitasFailure) {
                                    return Center(
                                      child: Text(
                                        'Gagal memuat data: ${state.error}',
                                      ),
                                    );
                                  } else if (state is FasilitasLoaded) {
                                    final List<DataFasilitas> fasilitasList =
                                        state.listFasilitas;
                                    if (fasilitasList.isEmpty) {
                                      return const Center(
                                        child: Text("Fasilitas belum tersedia"),
                                      );
                                    }
                                    // Daftar Kategori
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: fasilitasList.length,
                                      itemBuilder: (context, index) {
                                        final fasilitas = fasilitasList[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 30,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                0xFF003C97,
                                              ).withValues(alpha: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 15),
                                                Text(
                                                  fasilitas.namaFasilitas,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  fasilitas.namaProject,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                // edit kategori
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          final result = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => BlocProvider.value(
                                                                    value:
                                                                        context
                                                                            .read<
                                                                              FasilitasBloc
                                                                            >(),
                                                                    child: FasilitasEditScreen(
                                                                      fasilitas:
                                                                          fasilitas,
                                                                    ),
                                                                  ),
                                                            ),
                                                          );

                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }

                                                          if (result == true) {
                                                            context
                                                                .read<
                                                                  FasilitasBloc
                                                                >()
                                                                .add(
                                                                  FasilitasRequested(),
                                                                );
                                                          }
                                                        },
                                                        style: IconButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                0xFF0056D6,
                                                              ),
                                                          minimumSize:
                                                              const Size(
                                                                30,
                                                                30,
                                                              ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  5,
                                                                ),
                                                          ),
                                                        ),
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (
                                                              BuildContext
                                                              dialogContext,
                                                            ) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                ),
                                                                titlePadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                title: Container(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            12,
                                                                        horizontal:
                                                                            20,
                                                                      ),
                                                                  decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                            16,
                                                                          ),
                                                                        ),
                                                                    gradient: LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                          0xFF003C97,
                                                                        ),
                                                                        Color(
                                                                          0xFF0056D6,
                                                                        ),
                                                                        Color(
                                                                          0xFFFF7A00,
                                                                        ),
                                                                      ],
                                                                      stops: [
                                                                        0.0,
                                                                        0.6,
                                                                        4.0,
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  child: const Text(
                                                                    "Konfirmasi Hapus",
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),

                                                                // <- masih di dalam AlertDialog
                                                                content: Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            15,
                                                                      ),
                                                                  child: RichText(
                                                                    text: TextSpan(
                                                                      style: const TextStyle(
                                                                        color:
                                                                            Colors.black,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                      children: [
                                                                        const TextSpan(
                                                                          text:
                                                                              "Apakah anda yakin ingin menghapus ",
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              "${fasilitas.namaFasilitas}?",
                                                                          style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),

                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () =>
                                                                            Navigator.of(
                                                                              dialogContext,
                                                                            ).pop(),
                                                                    child: const Text(
                                                                      "Batal",
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Color(
                                                                            0xFF003C97,
                                                                          ),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                        dialogContext,
                                                                      ).pop();
                                                                      context
                                                                          .read<
                                                                            FasilitasBloc
                                                                          >()
                                                                          .add(
                                                                            FasilitasDeleted(
                                                                              fasilitas.idFasilitas,
                                                                            ),
                                                                          );
                                                                    },
                                                                    child: const Text(
                                                                      "Oke",
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        style: IconButton.styleFrom(
                                                          backgroundColor:
                                                              Color(0xFFAF3536),
                                                          minimumSize:
                                                              const Size(
                                                                30,
                                                                30,
                                                              ),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  5,
                                                                ),
                                                          ),
                                                        ),
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // tambah Fasilitas
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: context.read<FasilitasBloc>(),
                      child: FasilitasAddScreen(),
                    ),
              ),
            );

            if (!context.mounted) return;
            if (result != null && result == true) {
              context.read<FasilitasBloc>().add(FasilitasRequested());
            }
          },
          backgroundColor: Color(0xFF003C97),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
