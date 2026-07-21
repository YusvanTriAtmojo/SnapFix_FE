import 'package:damagereports/data/model/request/user/user_admin_request_model.dart';
import 'package:damagereports/data/model/response/project_response_model.dart';
import 'package:damagereports/data/model/response/role_response_model.dart';
import 'package:damagereports/presentation/admin/project/bloc/project_bloc.dart';
import 'package:damagereports/presentation/admin/role/bloc/role_bloc.dart';
import 'package:damagereports/presentation/admin/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAddScreen extends StatefulWidget {
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final _projectController = TextEditingController();
  final nipController = TextEditingController();
  final emailController = TextEditingController();
  final notlpController = TextEditingController();
  final alamatController = TextEditingController();
  final passwordController = TextEditingController();
  final _roleController = TextEditingController();

  List<DataProject> hasilProject = [];

  DataProject? selectedProject;

  List<DataRole> hasilRole = [];

  DataRole? selectedRole;

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(ProjectRequested());
    context.read<RoleBloc>().add(RoleRequested());
  }

  @override
  void dispose() {
    namaController.dispose();
    _projectController.dispose();
    nipController.dispose();
    emailController.dispose();
    notlpController.dispose();
    alamatController.dispose();
    passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFF003C97), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      "Tambah User",
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
                  child: BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) async {
                      if (state is UserOperationSuccess) {
                        await showDialog(
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
                        if (!context.mounted) return;
                        Navigator.pop(context, true);
                      } else if (state is UserFailure) {
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
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const Text(
                                "Nama",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: namaController,
                                decoration: InputDecoration(
                                  hintText: "Nama User",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF002F87),
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "NIP",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: nipController,
                                decoration: InputDecoration(
                                  hintText: "Masukkan NIP",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF002F87),
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'NIP wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Email",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Masukkan Email",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF002F87),
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Password",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: "Masukkan Password",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF002F87),
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Nomor Telepon",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: notlpController,
                                decoration: InputDecoration(
                                  hintText: "Masukkan Nomor Telepon",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF002F87),
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor Telepon wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Alamat",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: alamatController,
                                decoration: InputDecoration(
                                  hintText: "Masukkan Alamat",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF002F87),
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Alamat wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Role",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _roleController,
                                onChanged: (value) {
                                  final state = context.read<RoleBloc>().state;

                                  if (state is RoleLoaded) {
                                    hasilRole =
                                        state.listRole.where((role) {
                                          final namaRole =
                                              role.namaRole.toLowerCase();
                                          final input = value.toLowerCase();

                                          return namaRole.contains(input);
                                        }).toList();
                                  }

                                  setState(() {});
                                },
                                decoration: _fieldDecoration(
                                  hint: "Cari Role...",
                                  suffix: const Icon(
                                    Icons.search,
                                    color: Color(0xFF002F87),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Role wajib diisi';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),

                              if (hasilRole.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxHeight: 200,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: hasilRole.length,
                                    itemBuilder: (context, index) {
                                      final role = hasilRole[index];

                                      return ListTile(
                                        title: Text(
                                          role.namaRole,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedRole = role;
                                            _roleController.text =
                                                role.namaRole;
                                            hasilRole.clear();
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 10),
                              const Text(
                                "Project",
                                style: TextStyle(
                                  color: Color(0xFF002F87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _projectController,
                                onChanged: (value) {
                                  final state =
                                      context.read<ProjectBloc>().state;

                                  if (state is ProjectLoaded) {
                                    hasilProject =
                                        state.listProject.where((project) {
                                          final namaProject =
                                              project.namaProject.toLowerCase();
                                          final input = value.toLowerCase();

                                          return namaProject.contains(input);
                                        }).toList();
                                  }

                                  setState(() {});
                                },
                                decoration: _fieldDecoration(
                                  hint: "Cari project...",
                                  suffix: const Icon(
                                    Icons.search,
                                    color: Color(0xFF002F87),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Project wajib diisi';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),

                              if (hasilProject.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxHeight: 200,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: hasilProject.length,
                                    itemBuilder: (context, index) {
                                      final project = hasilProject[index];

                                      return ListTile(
                                        title: Text(
                                          project.namaProject,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedProject = project;
                                            _projectController.text =
                                                project.namaProject;
                                            hasilProject.clear();
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed:
                                    state is UserLoading
                                        ? null
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final requestModel =
                                                UserAdminRequestModel(
                                                  name: namaController.text,
                                                  nip: nipController.text,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  notlp: notlpController.text,
                                                  alamat: alamatController.text,
                                                  idRole: selectedRole!.idRole,
                                                  idProject:
                                                      selectedProject!
                                                          .idProject,
                                                );
                                            context.read<UserBloc>().add(
                                              UserCreateRequested(
                                                requestModel: requestModel,
                                              ),
                                            );
                                          }
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF003C97),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                child:
                                    state is UserLoading
                                        ? const CircularProgressIndicator(
                                          color: Color(0xFF002F87),
                                        )
                                        : const Text(
                                          "Simpan",
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),
                            ],
                          ),
                        ),
                      );
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
