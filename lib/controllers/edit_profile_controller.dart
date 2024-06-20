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

    // Load user data
    loadUserData();
  }

  @override
  void onClose() {
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
        usernameController.text = doc.data()?['username'] ?? '';
        emailController.text = doc.data()?['email'] ?? '';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> editProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Update Firestore
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      });

      // Update FirebaseAuth email if changed
      if (emailController.text.trim() !=
          FirebaseAuth.instance.currentUser!.email) {
        await FirebaseAuth.instance.currentUser!
            .verifyBeforeUpdateEmail(emailController.text.trim());
      }

      Get.snackbar('Success', 'Profile updated successfully');

      // Navigate back to the profile page and reload data
      Get.offAllNamed('/profil_page');
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  Future<void> deleteAccount() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(uid).delete();
      await FirebaseAuth.instance.currentUser!.delete();
      Get.snackbar('Success', 'Account deleted successfully');
      // Tambahan: tambahkan logika navigasi atau tindakan setelah menghapus akun
      Get.offAllNamed('/login');
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting account: $e');
      }
      Get.snackbar('Error', 'Failed to delete account');
    }
  }
}
