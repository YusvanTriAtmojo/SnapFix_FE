import 'dart:io';
import 'package:damagereports/presentation/klien/kerusakan/kerusakan_screen.dart';
import 'package:damagereports/presentation/klien/kerusakan/laporan_kerusakan_screen.dart';
import 'package:damagereports/presentation/klien/profile/klien_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class KlienScreen extends StatefulWidget {
  const KlienScreen({super.key});

  @override
  State<KlienScreen> createState() => _KlienScreenState();
}

class _KlienScreenState extends State<KlienScreen> {
  int pilihIndex = 0;
  bool _isRequestingCamera = false;

  Future<void> pilihHalaman(int index) async {
    if (index == 1) {
      if (_isRequestingCamera) return;

      setState(() {
        _isRequestingCamera = true;
      });

      try {
        var status = await Permission.camera.status;

        if (!status.isGranted) {
          status = await Permission.camera.request();

          if (!status.isGranted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Izin kamera ditolak, tidak bisa mengambil foto',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  duration: const Duration(seconds: 3),
                ),
              );
            }
            return;
          }
        }

        final picker = ImagePicker();

        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null && mounted) {
          final file = File(pickedFile.path);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LaporKerusakanScreen(foto: file)),
          );
        }
      } catch (e) {
        debugPrint('Terjadi kesalahan saat mengambil foto: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isRequestingCamera = false;
          });
        }
      }
    } else {
      setState(() {
        pilihIndex = index;
      });
    }
  }

  Widget halamanContent() {
    switch (pilihIndex) {
      case 0:
        return KerusakanScreen();
      case 2:
        return KlienProfileScreen();
      default:
        return Text('Halaman Kosong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: halamanContent(),

      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF003C97),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => pilihHalaman(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: 25,
                      color:
                          pilihIndex == 0 ? Color(0xFFFF7A00) : Colors.white70,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color:
                            pilihIndex == 0
                                ? Color(0xFFFF7A00)
                                : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 90),

            Expanded(
              child: InkWell(
                onTap: () => pilihHalaman(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 25,
                      color:
                          pilihIndex == 2 ? Color(0xFFFF7A00) : Colors.white70,
                    ),
                    Text(
                      'Profil',
                      style: TextStyle(
                        color:
                            pilihIndex == 2
                                ? Color(0xFFFF7A00)
                                : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: GestureDetector(
        onTap: () => pilihHalaman(1),
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(38), blurRadius: 15),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF7A00),
            ),
            child:
                _isRequestingCamera
                    ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 38,
                    ),
          ),
        ),
      ),
    );
  }
}
