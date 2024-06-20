import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileController extends GetxController {
  late TextEditingController usernameController;
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    emailController = TextEditingController();

    // Memuat data pengguna saat kontroler diinisialisasi
    loadUserData();
  }

  @override
  void onClose() {
    // Menghapus controller saat kontroler ditutup untuk mencegah memory leak
    usernameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        // Mengisi nilai controller dengan data pengguna jika tersedia
        usernameController.text = doc.data()?['username'] ?? '';
        emailController.text = doc.data()?['email'] ?? '';
      }
    } catch (e) {
      // Menangani error saat memuat data pengguna
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> editProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Memperbarui Firestore dengan username dan email baru
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      });

      // Memperbarui email di FirebaseAuth jika berubah
      if (emailController.text.trim() !=
          FirebaseAuth.instance.currentUser!.email) {
        await FirebaseAuth.instance.currentUser!
            .verifyBeforeUpdateEmail(emailController.text.trim());
      }

      // Menampilkan snackbar sukses dan kembali ke halaman profil
      Get.snackbar('Sukses', 'Profil berhasil diperbarui');
      Get.offAllNamed('/profil_page'); // Kembali ke halaman profil
    } catch (e) {
      // Menangani error saat memperbarui profil
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      Get.snackbar('Error', 'Gagal memperbarui profil');
    }
  }

  Future<void> deleteAccount() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Menghapus data pengguna dari Firestore dan akun Firebase
      await FirebaseFirestore.instance.collection('Users').doc(uid).delete();
      await FirebaseAuth.instance.currentUser!.delete();

      // Menampilkan snackbar sukses dan navigasi ke halaman login
      Get.snackbar('Sukses', 'Akun berhasil dihapus');
      Get.offAllNamed('/login'); // Navigasi ke halaman login setelah hapus akun
    } catch (e) {
      // Menangani error saat menghapus akun
      if (kDebugMode) {
        print('Error deleting account: $e');
      }
      Get.snackbar('Error', 'Gagal menghapus akun');
    }
  }
}
