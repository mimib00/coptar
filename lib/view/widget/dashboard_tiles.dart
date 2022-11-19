import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';

Widget dashBoardTiles(
    String title,
    projects,
    Color bgColor,
    VoidCallback onTap,
    ) {
  return SizedBox(
    height: 100,
    child: Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: RadiusHandler.roundedRadius9,
          shadowColor: bgColor.withOpacity(0.5),
          color: bgColor,
          elevation: 4,
          child: InkWell(
            onTap: onTap,
            borderRadius: RadiusHandler.radius10,
            splashColor: kPrimaryColor.withOpacity(0.1),
            highlightColor: kPrimaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: title,
                    size: 16,
                    weight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      MyText(
                        text: '$projects projects',
                        color: kPrimaryColor,
                      ),
                      Image.asset(
                        kArrowForward,
                        width: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            kLensEffect,
            height: 70,
          ),
        ),
      ],
    ),
  );
}