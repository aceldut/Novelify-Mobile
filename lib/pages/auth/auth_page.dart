import 'package:final_app/repository/auth_repository/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/pages/auth/login_page.dart';
import 'package:final_app/pages/auth/register_page.dart';

// Kelas AuthPage adalah StatelessWidget
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance AuthController menggunakan GetX
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      // Obx digunakan untuk mengamati perubahan state isLoginPage
      body: Obx(() {
        // Menampilkan halaman Login jika isLoginPage bernilai true
        if (authController.isLoginPage.value) {
          return LoginPage(
            onTap: () {
              // Mengubah halaman ke Register saat tombol di tekan
              authController.toggleAuthPage();
            },
          );
        } else {
          // Menampilkan halaman Register jika isLoginPage bernilai false
          return RegisterPage(
            onTap: () {
              // Mengubah halaman ke Login saat tombol di tekan
              authController.toggleAuthPage();
            },
          );
        }
      }),
    );
  }
}
