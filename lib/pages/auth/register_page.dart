import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/controllers/register_controller.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController = Get.find();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "DAFTAR",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    hintText: "Username",
                    obscureText: false,
                    controller: registerController.usernameController,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    hintText: "Email",
                    obscureText: false,
                    controller: registerController.emailController,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    hintText: "Password",
                    obscureText: true,
                    controller: registerController.passwordController,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    hintText: "Konfirmasi Password",
                    obscureText: true,
                    controller: registerController.confirmPwController,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: MyButton(
                      text: "Daftar",
                      onTap: () => registerController.registerUser(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Punya Akun?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          registerController.clearTextFields();
                          if (onTap != null) {
                            onTap!();
                          }
                        },
                        child: const Text(
                          " Masuk",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (registerController.isRegistering.value) {
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
