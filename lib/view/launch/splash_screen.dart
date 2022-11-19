/*
import 'package:copter/controller/splash_controller/splash_controller.dart';
*/
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/routes/routes.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root.dart';
import 'get_started.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserController userController = Get.find();

  @override
  void initState() {
    //set time to load the new page
    Future.delayed(const Duration(seconds: 2), () {
      loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*   return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (splashScreenController) {*/
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                text: 'Welcome',
                size: 24,
                weight: FontWeight.w600,
                color: kBlackColor2,
              ),
              MyText(
                paddingBottom: 25,
                text: 'to',
                size: 24,
                color: kBlackColor2,
              ),
            ],
          ),
          Center(
            child: Image.asset(
              kLogo,
              height: 108,
            ),
          ),
        ],
      ),
    );
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getKeys());

    if (prefs.containsKey('uid')) {
      userController.uid.value = prefs.getString('uid')!;
      userController.email.value = prefs.getString('email')!;
      userController.name.value = prefs.getString('name')!;
      userController.phone.value = prefs.getString('phone')!;
      userController.userType.value = prefs.getString('userType')!;
      userController.companyType.value = prefs.getString('companyType')!;
      userController.tagline.value = prefs.getString('tagline')!;

      userController.startUserDataStream();

      Get.off(() => const Root());
    } else if (prefs.containsKey('isFirstTime')) {
      Get.offNamed(AppLinks.login);
    } else {
      Get.off(() => const GetStarted());
    }
  }
}
