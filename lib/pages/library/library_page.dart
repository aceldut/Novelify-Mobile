import 'package:final_app/components/my_tabbar.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: const Text('Perpustakaan'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange.shade400,
        ),
        body: const MyTabBar());
  }
}
