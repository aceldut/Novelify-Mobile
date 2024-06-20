import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> loginUser() async {
    if (_validateInputs()) {
      isLoading.value = true;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Setelah berhasil login, langsung navigasi ke halaman '/home'
        Get.offAllNamed('/home_page');
      } on FirebaseAuthException catch (e) {
        String errorMessage = _mapFirebaseAuthErrorCode(e.code);
        Get.snackbar('Error', errorMessage);
      } catch (e) {
        Get.snackbar('Error', 'An error occurred');
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateInputs() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and Password cannot be empty');
      return false;
    }
    return true;
  }

  String _mapFirebaseAuthErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email';
      case 'wrong-password':
        return 'Wrong password provided for that user';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      default:
        return 'Login failed: $code';
    }
  }
}
