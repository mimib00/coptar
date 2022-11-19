import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_button.dart';
import 'my_text.dart';

// ignore: must_be_immutable
class NotificationTiles extends StatelessWidget {
  NotificationTiles({
    Key? key,
    this.msg,
    this.time,
    this.requestToJoin,
  }) : super(key: key);

  String? msg, time;
  bool? requestToJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MyText(
                  text: '$msg',
                  weight: FontWeight.w500,
                  paddingRight: 10,
                ),
              ),
              Image.asset(
                kCloseIcon,
                height: 22,
              ),
            ],
          ),
          requestToJoin!
              ? Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyButton(
                            onPressed: () {},
                            height: 42,
                            text: 'Accept',
                            textSize: 14,
                            weight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: RadiusHandler.radius10,
                              border: Border.all(
                                color: kBorderColor,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: MyText(
                                text: 'Cancel',
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: '$time',
                  size: 12,
                  color: kDarkPurpleColor,
                ),
                requestToJoin!
                    ? GestureDetector(
                        // onTap: () => Get.to(
                        //   () => TaskDashBoard(
                        //     // just for dummy data
                        //     uid:
                        //     projectTitle: 'Create a App Design',
                        //     urgentProject: true,
                        //     projectProgress: 10,
                        //     indicatorProgress: 0.1,
                        //     haveRequestToJoin: true,
                        //   ),
                        // ),
                        child: MyText(
                          text: 'View Details',
                          size: 12,
                          color: kDarkPurpleColor,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Container(
            height: 1,
            color: kLightPurpleColor2,
            width: Get.width,
          ),
        ],
      ),
    );
  }
}
