import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/components/my_textfield.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  final void Function()?
      onTap; // Fungsi callback yang dipanggil saat pengguna ingin mendaftar

  const LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Menggunakan GetX untuk mengelola state LoginController
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Menggunakan LayoutBuilder untuk membuat tampilan responsif
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Menampilkan logo
                        Image.asset(
                          'assets/logo.png',
                          width: constraints.maxWidth * 0.4,
                        ),
                        const SizedBox(height: 20),
                        // Menampilkan judul
                        const Text(
                          "MASUK",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Menampilkan TextField untuk email
                        MyTextfield(
                          hintText: "Email",
                          obscureText: false,
                          controller: loginController.emailController,
                        ),
                        const SizedBox(height: 10),
                        // Menampilkan TextField untuk password
                        MyTextfield(
                          hintText: "Password",
                          obscureText: true,
                          controller: loginController.passwordController,
                        ),
                        const SizedBox(height: 20),
                        // Menampilkan tombol login
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          child: Obx(() => MyButton(
                                text: "Masuk",
                                onTap: loginController.isLoading.value
                                    ? null
                                    : loginController.loginUser,
                              )),
                        ),
                        const SizedBox(height: 30),
                        // Menampilkan teks untuk pindah ke halaman pendaftaran
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Punya Akun?",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: onTap,
                              child: const Text(
                                " Daftar",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Menampilkan loading spinner saat login sedang diproses
          Obx(() {
            if (loginController.isLoading.value) {
              return Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
