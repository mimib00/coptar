/*
import 'package:copter/controller/login_controller/login_controller.dart';
*/
import 'package:copter/view/root.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Image.asset(
                kDoneIcon,
                height: 94,
              ),
            ),
          ),
          MyText(
            align: TextAlign.center,
            paddingTop: 20,
            text: 'Payment Successful',
            size: 18,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Center(
            child: SizedBox(
              width: Get.width * 0.8,
              child: MyButton(
                haveRoundedEdges: true,
                haveCustomElevation: true,
                onPressed: () => Get.offAll(
                  () => const Root(),
                ),
                text: 'Back to home',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
