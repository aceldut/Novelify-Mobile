import 'package:final_app/pages/home_page.dart';
import 'package:final_app/pages/library/library_page.dart';
import 'package:final_app/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 3,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.book),
              label: 'Perpustakaan',
            ),
          ],
          selectedIconTheme: IconThemeData(color: Colors.blue.shade900),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedItemColor: Colors.blue.shade900,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: Obx(() => controller.pages[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final pages = [const HomePage(), const SearchPage(), const LibraryPage()];
}
