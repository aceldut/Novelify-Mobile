import 'package:final_app/components/my_navbar.dart';
import 'package:final_app/pages/auth/auth_page.dart';
import 'package:final_app/pages/auth/login_or_register.dart';
import 'package:final_app/pages/auth/register_page.dart';
import 'package:final_app/pages/library/library_page.dart';
import 'package:final_app/pages/profile/profil_page.dart';
import 'package:final_app/pages/search_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  // Define constant route names
  static const String auth = '/auth';
  static const String loginRegister = '/login_register_page';
  static const String home = '/home_page';
  static const String profile = '/profil_page';
  static const String search = '/search_page';
  static const String library = '/library_page';
  static const String register = '/register_page';

  // Define pages and routes using GetPage
  static final List<GetPage> routes = [
    GetPage(
      name: auth,
      page: () => const AuthPage(), // Halaman autentikasi
    ),
    GetPage(
      name: loginRegister,
      page: () => const LoginOrRegister(), // Halaman login atau registrasi
    ),
    GetPage(
      name: home,
      page: () => const Navbar(), // Halaman utama dengan Navbar
    ),
    GetPage(
      name: profile,
      page: () => const ProfilPage(), // Halaman profil pengguna
    ),
    GetPage(
      name: search,
      page: () => const SearchPage(), // Halaman pencarian
    ),
    GetPage(
      name: library,
      page: () => const LibraryPage(), // Halaman perpustakaan
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(
        onTap: () => Get.toNamed(
            loginRegister), // Halaman registrasi dengan navigasi ke halaman login atau registrasi
      ),
    ),
  ];
}
