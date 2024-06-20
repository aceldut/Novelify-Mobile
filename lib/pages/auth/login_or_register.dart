import 'package:final_app/pages/auth/login_page.dart';
import 'package:final_app/pages/auth/register_page.dart';
import 'package:flutter/material.dart';

// Kelas LoginOrRegister adalah StatefulWidget
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage =
      true; // Menyimpan status apakah halaman login atau registrasi yang ditampilkan

  // Fungsi untuk toggle antara halaman login dan registrasi
  void togglePages() {
    setState(() {
      showLoginPage =
          !showLoginPage; // Mengubah nilai boolean untuk menampilkan halaman yang sesuai
    });
  }

  @override
  Widget build(BuildContext context) {
    // Memilih halaman yang akan ditampilkan berdasarkan nilai showLoginPage
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages, // Memberikan fungsi togglePages ke halaman login
      );
    } else {
      return RegisterPage(
        onTap:
            togglePages, // Memberikan fungsi togglePages ke halaman registrasi
      );
    }
  }
}
