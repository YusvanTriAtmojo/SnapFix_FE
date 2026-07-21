import 'package:damagereports/data/model/response/project_response_model.dart';
import 'package:damagereports/data/model/response/user_all_response_model.dart';
import 'package:damagereports/presentation/admin/project/bloc/project_bloc.dart';
import 'package:damagereports/presentation/admin/user/bloc/user_bloc.dart';
import 'package:damagereports/presentation/admin/user/user_add_screen.dart';
import 'package:damagereports/presentation/admin/user/user_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedProject = 'Semua';

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(UserRequested());
    context.read<ProjectBloc>().add(ProjectRequested());

    _searchController.addListener(() {
      final query = _searchController.text;

      if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(query)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Nama pegawai hanya bisa dicari dengan huruf.",
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
      context.read<UserBloc>().add(UserFiltered(query));
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
                      "Daftar User",
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
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
                            hintText: 'Cari nama User',
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
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
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
                                                          .read<UserBloc>()
                                                          .add(
                                                            UserRequested(
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
                                                                    ? Colors
                                                                        .white
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
                                child: BlocConsumer<UserBloc, UserState>(
                                  listener: (context, state) {
                                    if (state is UserFailure) {
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
                                                          shape:
                                                              BoxShape.circle,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    } else if (state is UserOperationSuccess) {
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
                                                          shape:
                                                              BoxShape.circle,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    if (state is UserLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF003C97),
                                        ),
                                      );
                                    } else if (state is UserFailure) {
                                      return Center(
                                        child: Text(
                                          'Gagal memuat data: ${state.error}',
                                        ),
                                      );
                                    } else if (state is UserLoaded) {
                                      final List<DataAdminUser> userList =
                                          state.listUser;
                                      if (userList.isEmpty) {
                                        return const Center(
                                          child: Text("User belum tersedia"),
                                        );
                                      }
                                      // Daftar Kategori
                                      return ListView.builder(
                                        padding: const EdgeInsets.all(16),
                                        itemCount: userList.length,
                                        itemBuilder: (context, index) {
                                          final user = userList[index];

                                          Widget item(
                                            String title,
                                            String value,
                                          ) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 0.5,
                                                  ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 85,
                                                    child: Text(
                                                      title,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF002F87,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    ": ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF003C97,
                                                ).withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        item("Nama", user.name),
                                                        item("NIP", user.nip),
                                                        item(
                                                          "Email",
                                                          user.email,
                                                        ),
                                                        item(
                                                          "Role",
                                                          user.namaRole,
                                                        ),
                                                        item(
                                                          "Project",
                                                          user.namaProject,
                                                        ),
                                                        item(
                                                          "No. Telepon",
                                                          user.notlp,
                                                        ),
                                                        item(
                                                          "Alamat",
                                                          user.alamat,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  const SizedBox(width: 12),

                                                  Column(
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
                                                                              UserBloc
                                                                            >(),
                                                                    child: UserEditScreen(
                                                                      user:
                                                                          user,
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
                                                                  UserBloc
                                                                >()
                                                                .add(
                                                                  UserRequested(),
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

                                                      const SizedBox(
                                                        height: 10,
                                                      ),

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
                                                                              "${user.name}?",
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
                                                                            UserBloc
                                                                          >()
                                                                          .add(
                                                                            UserDeleted(
                                                                              user.id,
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
            ),
          ],
        ),
      ),

      // tambah User
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: context.read<UserBloc>(),
                      child: UserAddScreen(),
                    ),
              ),
            );

            if (!context.mounted) return;
            if (result != null && result == true) {
              context.read<UserBloc>().add(UserRequested());
            }
          },
          backgroundColor: Color(0xFF003C97),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
