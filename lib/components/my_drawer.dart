import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  bool _loggingOut = false; // Track if logout process is ongoing

  // Logout user
  Future<void> logout() async {
    setState(() {
      _loggingOut = true; // Start logout process, set loading indicator
    });

    try {
      await FirebaseAuth.instance.signOut();

      // Navigate to login page after successful logout and remove all previous routes
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login_register_page',
          (route) => false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Logout error: $e");
      }
      // Handle logout error here
      // You can show a snackbar or display an error message
    } finally {
      // Ensure to reset state and dismiss loading indicator
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
              // Profile tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('P R O F I L'),
                  ),
                  onTap: () {
                    // Pop drawer
                    Navigator.pop(context);

                    // Navigate to profile page
                    Navigator.pushNamed(context, '/profil_page');
                  },
                ),
              ),
            ],
          ),
          // Logout tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('K E L U A R'),
              ),
              onTap: _loggingOut
                  ? null // Disable tap when logging out
                  : () {
                      // Pop drawer
                      Navigator.pop(context);

                      // Initiate logout process
                      logout();
                    },
            ),
          ),
        ],
      ),
    );
  }
}
