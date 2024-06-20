import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onClose() {
    // Membersihkan controller saat kontroler ditutup untuk mencegah memory leak
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> loginUser() async {
    // Validasi input sebelum melakukan login
    if (_validateInputs()) {
      isLoading.value = true;
      try {
        // Melakukan login dengan Firebase Authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Navigasi ke halaman '/home' setelah login berhasil
        Get.offAllNamed('/home_page');
      } on FirebaseAuthException catch (e) {
        // Menangkap kesalahan Firebase Authentication dan menampilkan pesan kesalahan yang sesuai
        String errorMessage = _mapFirebaseAuthErrorCode(e.code);
        Get.snackbar('Error', errorMessage);
      } catch (e) {
        // Menangkap kesalahan umum selama proses login
        Get.snackbar('Error', 'Terjadi kesalahan');
      } finally {
        // Menghentikan loading setelah proses selesai, baik berhasil maupun gagal
        isLoading.value = false;
      }
    }
  }

  bool _validateInputs() {
    // Validasi bahwa email dan password tidak boleh kosong
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan Password tidak boleh kosong');
      return false;
    }
    return true;
  }

  String _mapFirebaseAuthErrorCode(String code) {
    // Mapping kode kesalahan Firebase Authentication ke pesan kesalahan yang lebih deskriptif
    switch (code) {
      case 'user-not-found':
        return 'Tidak ada pengguna dengan email tersebut';
      case 'wrong-password':
        return 'Password yang dimasukkan salah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login yang gagal. Silakan coba lagi nanti.';
      case 'invalid-email':
        return 'Email tidak valid';
      case 'user-disabled':
        return 'Pengguna dengan email ini telah dinonaktifkan';
      case 'operation-not-allowed':
        return 'Operasi ini tidak diizinkan';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa jaringan Anda dan coba lagi';
      default:
        return 'Login gagal: $code';
    }
  }
}
