import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget backButton() {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => Get.back(),
      icon: Container(
        height: 40,
        width: 40,
        decoration: iconBg,
        child: Center(
          child: Image.asset(
            kArrowBack,
            width: 24,
          ),
        ),
      ),
    ),
  );
}