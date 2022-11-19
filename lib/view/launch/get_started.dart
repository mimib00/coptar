import 'package:copter/routes/routes.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    setKeyInSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 6,
              child: Image.asset(
                kGetStartedImage,
                width: Get.width,
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: 'Manage Your Daily Task',
                        size: 24,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                        paddingBottom: 10.0,
                      ),
                      MyText(
                        text:
                            'You can organize your daily projects and tasks on a reqular basis and manage your time well and neatly.',
                        weight: FontWeight.w300,
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: Get.width * 0.6,
                      child: MyButton(
                        /*onPressed: () => Get.offNamed(AppLinks.login),*/
                        onPressed: () => Get.offNamed(AppLinks.login),
                        haveRoundedEdges: true,
                        text: 'Get Started',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setKeyInSharedPref() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isFirstTime', false);
    });
  }
}
