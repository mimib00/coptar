/*
import 'package:copter/controller/login_controller/login_controller.dart';
*/
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/routes/bindings.dart';
import 'package:copter/routes/routes.dart';
import 'package:copter/view/calendar/calendar.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'back_button.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.title,
  }) : super(key: key);
  String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: backButton(),
      title: MyText(
        text: '$title',
        weight: FontWeight.w500,
        color: kBlackColor2,
        size: 14,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class CustomAppBarWithLogo extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWithLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          // Get.toNamed(AppLinks.eProfile);
          Get.find<UserController>().userType.value == 'company'
              ? Get.toNamed(AppLinks.cProfile)
              : Get.toNamed(AppLinks.eProfile);
        },
        icon: SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: Image.asset(
              kMenuIcon,
              height: 20,
            ),
          ),
        ),
      ),
      title: Image.asset(
        kLogoSmall,
        height: 40,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(
            child: IconButton(
              onPressed: () => Get.to(const Calendar(), binding: CalanderBindings()),
              padding: EdgeInsets.zero,
              icon: Container(
                height: 40,
                width: 40,
                decoration: iconBg,
                child: Center(
                  child: Image.asset(
                    kCalendarIcon,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
