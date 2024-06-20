import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPwController = TextEditingController();
  var isRegistering = false.obs;

  void registerUser() async {
    isRegistering.value = true;

    if (passwordController.text != confirmPwController.text) {
      Get.snackbar('Error', 'Passwords do not match!');
      isRegistering.value = false;
      return;
    }

    try {
      // Validasi terlebih dahulu apakah email sudah terdaftar di Cloud Firestore
      final isEmailRegistered =
          await isEmailAlreadyRegistered(emailController.text.trim());
      if (isEmailRegistered) {
        Get.snackbar('Error', 'Email is already registered');
        isRegistering.value = false;
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Tunggu navigasi selesai sebelum membersihkan nilai isRegistering
      await createUserDocument(userCredential);

      // Navigasi ke halaman home hanya jika pendaftaran berhasil
      await Get.offAllNamed('/home_page');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'Email is already registered');
      } else {
        Get.snackbar('Error', e.message ?? 'An error occurred');
      }
      isRegistering.value = false; // Set nilai kembali setelah kesalahan
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      isRegistering.value = false; // Set nilai kembali setelah kesalahan
    }
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      // Lakukan pencarian di Cloud Firestore
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      // Jika ada dokumen yang ditemukan, email sudah terdaftar
      return query.docs.isNotEmpty;
    } catch (e) {
      // Tangani kesalahan secara tepat
      if (kDebugMode) {
        print('Error checking email registration: $e');
      }
      rethrow; // Lepaskan pengecualian untuk ditangani di luar
    }
  }

  Future<void> createUserDocument(UserCredential userCredential) async {
    if (userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'passwordHash': passwordController.text
            .hashCode, // Ini hanya contoh, perlu pertimbangan keamanan lebih lanjut
      });
    }
  }

  void clearTextFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPwController.clear();
  }

  @override
  void dispose() {
    // Bersihkan instance TextEditingController
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }
}
