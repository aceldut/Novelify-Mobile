import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  var isLoginPage = true
      .obs; // Variabel untuk menentukan apakah halaman login atau registrasi yang ditampilkan
  var isLoggedIn = false.obs; // Variabel untuk menentukan status login pengguna
  User? currentUser; // Variabel untuk menyimpan data pengguna yang sedang login
  RxString username = ''.obs; // Variabel reaktif untuk nama pengguna
  RxString email = ''.obs; // Variabel reaktif untuk alamat email pengguna
  RxString password = ''.obs; // Variabel reaktif untuk password pengguna

  // Fungsi untuk mengganti halaman antara login dan registrasi
  void toggleAuthPage() {
    isLoginPage.value = !isLoginPage.value;
  }

  @override
  void onInit() {
    // Cek apakah pengguna sudah login saat aplikasi dimulai
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUser = user;
      isLoggedIn.value = true;
      // Memuat data pengguna dari Firestore saat aplikasi dimulai
      loadUserData(user.uid);
    }
    super.onInit();
  }

  // Fungsi untuk melakukan login
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      currentUser = userCredential.user;
      isLoggedIn.value = true;
      // Memuat data pengguna dari Firestore setelah login berhasil
      loadUserData(currentUser!.uid);
    } catch (e) {
      handleAuthError('Login Failed', e);
    }
  }

  // Fungsi untuk melakukan registrasi
  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      currentUser = userCredential.user;
      isLoggedIn.value = true;
      // Membuat dokumen pengguna di Firestore setelah registrasi berhasil
      await createUserDocument(currentUser!.uid, email);
      // Memuat data pengguna dari Firestore setelah registrasi berhasil
      loadUserData(currentUser!.uid);
    } catch (e) {
      handleAuthError('Registration Failed', e);
    }
  }

  // Fungsi untuk melakukan logout
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Menghapus data pengguna dari state aplikasi saat logout
      clearUserData();
    } catch (e) {
      handleAuthError('Sign Out Failed', e);
    }
  }

  // Fungsi untuk memuat data pengguna dari Firestore berdasarkan UID
  Future<void> loadUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        username.value = doc.data()?['username'] ?? '';
        email.value = doc.data()?['email'] ?? '';
      }
    } catch (e) {
      handleAuthError('Error loading user data', e);
    }
  }

  // Fungsi untuk memperbarui profil pengguna di Firestore
  Future<void> updateProfile(String newUsername, String newEmail) async {
    try {
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            .update({
          'username': newUsername,
          'email': newEmail,
        });
        // Memperbarui data pengguna di state aplikasi
        username.value = newUsername;
        email.value = newEmail;
        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (e) {
      handleAuthError('Error updating profile', e);
    }
  }

  // Fungsi untuk memperbarui password pengguna di Firebase Authentication
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      handleAuthError('Error updating password', e);
    }
  }

  // Fungsi untuk membuat dokumen pengguna baru di Firestore saat registrasi
  Future<void> createUserDocument(String uid, String email) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'email': email,
        'username': '',
      });
    } catch (e) {
      handleAuthError('Error creating user document', e);
    }
  }

  // Fungsi untuk menangani error pada operasi autentikasi
  void handleAuthError(String title, dynamic e) {
    if (kDebugMode) {
      print('$title: $e');
    }
    Get.snackbar(title, e.toString());
  }

  // Fungsi untuk menghapus data pengguna dari state aplikasi saat logout
  void clearUserData() {
    currentUser = null;
    isLoggedIn.value = false;
    username.value = '';
    email.value = '';
    password.value = '';
  }
}
