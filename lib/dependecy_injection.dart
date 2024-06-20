import 'package:final_app/controllers/register_controller.dart';
import 'package:final_app/repository/auth_repository/auth.dart';
import 'package:get/get.dart';
import 'package:final_app/controllers/login_controller.dart';

class DependencyInjection {
  static void init() {
    // Menetapkan controller dan repositori yang di-inisialisasi secara lazy menggunakan GetX
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
