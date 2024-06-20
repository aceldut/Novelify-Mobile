import 'package:final_app/controllers/register_controller.dart';
import 'package:final_app/repository/auth_repository/auth.dart';
import 'package:get/get.dart';
import 'package:final_app/controllers/login_controller.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<RegisterController>(() => RegisterController());
    // Add other controllers and services here
  }
}
