import 'package:damagereports/presentation/admin/fasilitas/fasilitas_screen.dart';
import 'package:damagereports/presentation/admin/kerusakan/kerusakan_screen.dart';
import 'package:damagereports/presentation/admin/lokasi/lokasi_screen.dart';
import 'package:damagereports/presentation/admin/project/project_screen.dart';
import 'package:damagereports/presentation/admin/roleakses/roleakses_screen.dart';
import 'package:damagereports/presentation/admin/user/user_screen.dart';
import 'package:damagereports/presentation/admin/home/header_landing.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String imagePath,
    required String label, 
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), 
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 3;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7A8FB1),
              Color(0xFFE7EBFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const HeaderLanding(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 246, 253),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1, 
                          children: [
                            _buildMenuItem(
                              context: context,
                              imagePath: 'assets/images/fasilitas.png',
                              label: 'Fasilitas', 
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FasilitasScreen()),
                              ),
                            ),
                            _buildMenuItem(
                              context: context,
                              imagePath: 'assets/images/lokasi.png',
                              label: 'Lokasi', 
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LokasiScreen()),
                              ),
                            ),
                            _buildMenuItem(
                              context: context,
                              imagePath: 'assets/images/project.png',
                              label: 'Project', 
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProjectScreen()),
                              ),
                            ),
                            _buildMenuItem(
                              context: context,
                              imagePath: 'assets/images/user.png',
                              label: 'User', 
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const UserScreen()),
                              ),
                            ),
                            _buildMenuItem(
                              context: context,
                              imagePath: 'assets/images/roleakses.png',
                              label: 'Akses', 
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RoleaksesScreen()),
                              ),
                            ),
                            _buildMenuItem(
                              context: context,
                              imagePath: 'assets/images/kerusakan.png',
                              label: 'Kerusakan', 
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const KerusakanScreen()),
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}