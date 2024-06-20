import 'package:final_app/dependecy_injection.dart';
import 'package:final_app/firebase_options.dart';
import 'package:final_app/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

void main() async {
  // Pastikan binding Flutter sudah terinisialisasi sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await initializeFirebase();

  // Inisialisasi dependency injection
  DependencyInjection.init();

  // Jalankan aplikasi
  runApp(const MyApp());
}

// Fungsi untuk menginisialisasi Firebase
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Sembunyikan banner debug
      theme: lightMode, // Atur tema aplikasi
      initialRoute: AppRoutes.auth, // Rute awal aplikasi
      getPages: AppRoutes.routes, // Daftar rute aplikasi
    );
  }
}
