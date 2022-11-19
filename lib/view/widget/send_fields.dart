import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SendField extends StatelessWidget {
  SendField({
    Key? key,
    this.hintText,
    this.controller,
   required this.onTap,

  }) : super(key: key);
  void Function() onTap;

  String? hintText;
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        height: 80,
        width: Get.width,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.03),
              offset: const Offset(0, -1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              kAttachFiles,
              height: 18,
            ),
            const SizedBox(
              width: 20,
            ),
            Image.asset(
              kVoiceMsg,
              height: 20,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                cursorColor: kSecondaryColor,
                style: const TextStyle(
                  fontSize: 14,
                  color: kBlackColor2,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(

                        onTap: onTap,
                        child: Image.asset(
                          kSendButton,
                          height: 18,
                        ),
                      ),
                    ],
                  ),
                  hintText: hintText,
                  filled: true,
                  fillColor: kPrimaryColor,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: kBlackColor2,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: kSecondaryColor.withOpacity(0.1),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: kSecondaryColor.withOpacity(0.1),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
