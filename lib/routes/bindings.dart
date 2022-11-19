import 'package:copter/Controllers/calander_controller.dart';
import 'package:copter/Controllers/loginController.dart';
import 'package:copter/Controllers/userController.dart';
import 'package:get/get.dart';

//implement get bindings
class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class UserBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}

class CalanderBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CalanderController());
  }
}
