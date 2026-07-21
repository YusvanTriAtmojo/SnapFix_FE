import 'package:damagereports/data/repository/akses_repository.dart';
import 'package:damagereports/data/repository/fasilitas_repository.dart';
import 'package:damagereports/data/repository/kerusakan_admin_repository.dart';
import 'package:damagereports/data/repository/kerusakan_repository.dart';
import 'package:damagereports/data/repository/login_repository.dart';
import 'package:damagereports/data/repository/lokasi_repository.dart';
import 'package:damagereports/data/repository/project_repository.dart';
import 'package:damagereports/data/repository/role_repository.dart';
import 'package:damagereports/data/repository/roleakses_repository.dart';
import 'package:damagereports/data/repository/user_repository.dart';
import 'package:damagereports/presentation/admin/admin_screen.dart';
import 'package:damagereports/presentation/admin/akses/bloc/akses_bloc.dart';
import 'package:damagereports/presentation/admin/fasilitas/bloc/fasilitas_bloc.dart';
import 'package:damagereports/presentation/admin/kerusakan/bloc/kerusakan_admin_bloc.dart';
import 'package:damagereports/presentation/admin/lokasi/bloc/lokasi_bloc.dart';
import 'package:damagereports/presentation/admin/project/bloc/project_bloc.dart';
import 'package:damagereports/presentation/admin/role/bloc/role_bloc.dart';
import 'package:damagereports/presentation/admin/roleakses/bloc/roleakses_bloc.dart';
import 'package:damagereports/presentation/admin/user/bloc/user_bloc.dart';
import 'package:damagereports/presentation/auth/bloc/login_bloc.dart';
import 'package:damagereports/presentation/auth/login_screen.dart';
import 'package:damagereports/presentation/klien/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/klien/bloc/klien/klien_bloc.dart';
import 'package:damagereports/presentation/klien/home/klien_screen.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/kerusakan/kerusakan_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/bloc/teknisi_pic/teknisi_pic_bloc.dart';
import 'package:damagereports/presentation/teknisi_pic/home/teknisi_pic_screen.dart';
import 'package:damagereports/service/firebase_messaging_service.dart';
import 'package:damagereports/service/service_http_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final RouteObserver<ModalRoute> routeObserver =
    RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessagingService.initialize();

  final authRepo = AuthRepository(ServiceHttpClient());
  final storage = const FlutterSecureStorage();

  Widget startPage;

  final isLoggedIn = await authRepo.isLoggedIn();

  if (isLoggedIn) {
    final role = await storage.read(key: "userRole");

    switch (role) {
      case "klien":
        startPage = const KlienScreen(); 
      break;
      case "admin":
        startPage =  AdminScreen(); 
      break;
      case "teknisi":
        startPage = const TeknisiPicScreen();
      break;
      default:
        startPage = const LoginScreen();
    }
  } else {
    startPage = const LoginScreen();
  }

  runApp(MyApp(startPage: startPage));
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp({super.key, required this.startPage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            authRepository: AuthRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => KlienBloc(
            klienRepository: UserRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => KerusakanBloc(
            kerusakanRepository: KerusakanRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => KerusakanAdminBloc(
            kerusakanRepository: KerusakanAdminRepository(ServiceHttpClient()),
          ),
        ),
         BlocProvider(
          create: (context) => KerusakanKlienBloc(
            kerusakanKlienRepository: KerusakanRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => TeknisiPicBloc(
            teknisiPicRepository: UserRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => FasilitasBloc(
            fasilitasRepository: FasilitasRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => LokasiBloc(
            lokasiRepository: LokasiRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => ProjectBloc(
            projectRepository: ProjectRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => ProjectBloc(
            projectRepository: ProjectRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => AksesBloc(
            aksesRepository: AksesRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => RoleaksesBloc(
            roleaksesRepository: RoleAksesRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => RoleBloc(
            roleRepository: RoleRepository(ServiceHttpClient()),
          ),
        ),
         BlocProvider(
          create: (context) => UserBloc(
            userRepository: UserRepository(ServiceHttpClient()),
          ),
        ),
      ],
      
      child: MaterialApp(
        builder: (context, child) {
          return SafeArea(child: child!);
        },
        title: 'SnapFix',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF003D7A),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF003D7A), 
            selectionColor: Color(0xFF003D7A),
            selectionHandleColor: Color(0xFF003D7A),
          ),
        ),
        home: startPage,
      ),
    );
  }
}