import 'package:copter/Controllers/login_controller.dart';
import 'package:copter/Controllers/notification_controller.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/routes/routes.dart';
import 'firebase_options.dart';
import 'package:copter/view/constant/app_styling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initBindings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (UserController userController) {
      return GetMaterialApp(
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        title: 'Copter',
        theme: AppStyling.styling,
        initialRoute: AppLinks.splashScreen,
        getPages: AppRoutes.pages,
        themeMode: ThemeMode.light,
      );
    });
  }
}

Future<void> initBindings() async {
  Get.put(NotificationController(), permanent: true);
  Get.lazyPut<LoginController>(() => LoginController());
  Get.lazyPut<UserController>(() => UserController());
}
