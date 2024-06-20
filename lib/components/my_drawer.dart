import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key});

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  bool _loggingOut = false; // Memantau proses logout

  // Fungsi untuk logout
  Future<void> logout() async {
    setState(() {
      _loggingOut =
          true; // Memulai proses logout, menampilkan indikator loading
    });

    try {
      await FirebaseAuth.instance.signOut();

      // Navigasi ke halaman login setelah logout berhasil dan menghapus semua rute sebelumnya
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login_register_page',
          (route) => false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error logout: $e");
      }
      // Tangani kesalahan logout di sini
      // Anda bisa menampilkan snackbar atau pesan kesalahan
    } finally {
      // Pastikan mereset state dan menutup indikator loading
      if (mounted) {
        setState(() {
          _loggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 25),
              // Tile profil
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('P R O F I L'),
                  ),
                  onTap: () {
                    // Tutup drawer
                    Navigator.pop(context);

                    // Navigasi ke halaman profil
                    Navigator.pushNamed(context, '/profil_page');
                  },
                ),
              ),
            ],
          ),
          // Tile logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('K E L U A R'),
              ),
              onTap: _loggingOut
                  ? null // Menonaktifkan tap saat proses logout berlangsung
                  : () {
                      // Tutup drawer
                      Navigator.pop(context);

                      // Memulai proses logout
                      logout();
                    },
            ),
          ),
        ],
      ),
    );
  }
}
