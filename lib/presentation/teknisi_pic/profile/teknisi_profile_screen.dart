import 'package:damagereports/data/model/response/user_response_model.dart';
import 'package:damagereports/presentation/auth/bloc/login_bloc.dart';
import 'package:damagereports/presentation/auth/login_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/teknisi_pic/teknisi_pic_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/profile/teknisi_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeknisiProfileScreen extends StatefulWidget {
  const TeknisiProfileScreen({super.key});

  @override
  State<TeknisiProfileScreen> createState() => _TeknisiProfileScreenState();
}

class _TeknisiProfileScreenState extends State<TeknisiProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeknisiPicBloc>().add(GetTeknisiPicProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7A8FB1), Color(0xFFE7EBFF)],
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<TeknisiPicBloc, TeknisiPicState>(
              builder: (context, state) {
                if (state is TeknisiPicLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF002F87)),
                  );
                } else if (state is TeknisiPicFailure) {
                  return Center(
                    child: Text("Gagal memuat data: ${state.error}"),
                  );
                } else if (state is TeknisiPicLoaded) {
                  final DataUser teknisi = state.teknisiPic;

                  return ListView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 60,
                    ),
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                titlePadding: EdgeInsets.zero,
                                title: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 20,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF003C97),
                                        Color(0xFF0056D6),
                                        Color(0xFFFF7A00),
                                      ],
                                    ),
                                  ),
                                  child: const Text(
                                    "Konfirmasi Logout",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                content: const Text(
                                  "Apakah Anda yakin ingin keluar dari aplikasi?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text(
                                      "Batal",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFAF3536),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      context.read<LoginBloc>().add(
                                        LogoutRequested(),
                                      );
                                    },
                                    child: const Text(
                                      "Keluar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF002F87),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Data Diri",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002F87),
                        ),
                      ),
                      const SizedBox(height: 10),
                      dataProfile(Icons.person, "Nama", teknisi.name),
                      dataProfile(Icons.key_outlined, "NIP", teknisi.nip),
                      dataProfile(Icons.email, "Email", teknisi.email),
                      dataProfile(Icons.phone, "Nomor Telepon", teknisi.notlp),
                      dataProfile(Icons.location_on, "Alamat", teknisi.alamat),
                    ],
                  );
                } else {
                  return const Center(child: Text("Belum ada data Teknisi"));
                }
              },
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: FloatingActionButton(
            onPressed: () async {
              final state = context.read<TeknisiPicBloc>().state;
              if (state is TeknisiPicLoaded) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            TeknisiEditScreen(teknisi: state.teknisiPic),
                  ),
                );
                if (!context.mounted) return;
                if (result == true) {
                  context.read<TeknisiPicBloc>().add(
                    GetTeknisiPicProfileRequested(),
                  );
                }
              }
            },
            backgroundColor: Color(0xFF002F87),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget dataProfile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF003C97),
            blurRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFF7A00)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002C5A),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
