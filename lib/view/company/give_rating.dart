import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class GiveRating extends StatelessWidget {
  const GiveRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Rated',
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: defaultPadding,
        itemCount: 1,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return publicProfileTiles(
            'assets/images/dummy_public_accounts/d1.png',
            'Livia Lipshutz',
            'UI UX Designer',
          );
        },
      ),
    );
  }

  Widget publicProfileTiles(String? profileImage, name, status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: RadiusHandler.radius10,
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 8,
            color: kBlackColor.withOpacity(0.04),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Get.dialog(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RadiusHandler.roundedRadius10,
                margin: EdgeInsets.zero,
                color: kPrimaryColor,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  width: Get.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Image.asset(
                              kCloseIcon,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: const Color(0xffEEEEFF),
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: kYellowColor,
                          ),
                          glow: false,
                          onRatingUpdate: (rating) {
                            if (kDebugMode) {
                              print(rating);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        maxLines: 4,
                        style: TextFieldStyling.textStyle2,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Type here...',
                          hintStyle: TextFieldStyling.hintStyle2,
                          enabledBorder: TextFieldStyling.roundedBorder,
                          focusedBorder: TextFieldStyling.roundedBorder,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MyButton(
                            onPressed: () => Get.back(),
                            height: 40,
                            text: 'Send',
                            textSize: 14,
                            weight: FontWeight.w400,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        leading: ClipRRect(
          borderRadius: RadiusHandler.radius10,
          child: Image.asset(
            profileImage!,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
        ),
        title: MyText(
          text: name,
          weight: FontWeight.w500,
        ),
        subtitle: MyText(
          text: status,
          size: 12,
        ),
      ),
    );
  }
}
