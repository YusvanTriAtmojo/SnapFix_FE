import 'package:damagereports/data/model/request/auth/login_request_model.dart';
import 'package:damagereports/presentation/admin/admin_screen.dart';
import 'package:damagereports/presentation/auth/bloc/login_bloc.dart';
import 'package:damagereports/presentation/klien/home/klien_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginButtonFunction extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButtonFunction({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
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
        } else if (state is LoginSuccess) {
          final userData = state.responseModel.user;
          final role = userData.role;
          final name = userData.name;
          final userId = userData.id;
          final akses = userData.akses;

          final prefs = await SharedPreferences.getInstance();
          final storage = const FlutterSecureStorage();

          await prefs.setString('name', name);
          await prefs.setString('role', role);
          await prefs.setStringList('akses', akses);

          await prefs.setInt('userId', userId);

          // Tambahan untuk auto login
          await storage.write(key: "userRole", value: role);
          await storage.write(key: "isLoggedIn", value: "true");
          await storage.write(key: "userId", value: userId.toString());

          if (!context.mounted) return;

          if (role == 'teknisi') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const TeknisiPicScreen()),
              (route) => false,
            );
          } else if (role == 'klien') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const KlienScreen()),
              (route) => false,
            );
          } else if (role == 'admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const AdminScreen()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Akun tidak dikenali',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                state is LoginLoading
                    ? null
                    : () {
                      if (formKey.currentState!.validate()) {
                        final request = LoginRequestModel(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        context.read<LoginBloc>().add(
                          LoginRequested(requestModel: request),
                        );
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D7A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              state is LoginLoading ? 'Memuat...' : 'Masuk',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
