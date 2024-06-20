import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/pages/profile/edit_profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:final_app/repository/auth_repository/auth.dart'; // Import AuthController

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthController authController =
      Get.put(AuthController()); // Inisialisasi AuthController

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("Users")
          .doc(authController.currentUser!.uid)
          .get();

      return snapshot.data();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user details: $e");
      }
      return null;
    }
  }

  bool _loggingOut = false;

  Future<void> _signOut() async {
    setState(() {
      _loggingOut = true;
    });

    try {
      await authController.signOut();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login_register_page',
        (route) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Logout error: $e");
      }
      // Handle logout error here
    } finally {
      if (mounted) {
        setState(() {
          _loggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.orange.shade400,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(
                '/home_page'); // Ensure this onPressed callback calls Get.back()
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          // Data received
          if (snapshot.hasData && snapshot.data != null) {
            // Extract data
            Map<String, dynamic> user = snapshot.data!;

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile pic
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Username
                    Text(
                      user['username'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Email
                    Text(
                      user['email'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: MyButton(
                        text: 'Edit Profil',
                        onTap: () {
                          Get.to(() => EditProfilePage());
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Informasi
                    ListTile(
                      onTap: () {},
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.deepPurpleAccent.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      title: const Text('Informasi'),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Iconsax.arrow_right_3,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Keluar
                    ListTile(
                      onTap: _loggingOut ? null : _signOut,
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.redAccent.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.logout_outlined,
                          color: Colors.redAccent,
                        ),
                      ),
                      title: const Text(
                        'Keluar',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Iconsax.arrow_right_3,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text("Data Tidak Ada");
          }
        },
      ),
    );
  }
}
