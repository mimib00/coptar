import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class ReviewWidget extends StatelessWidget {
  ReviewWidget({
    Key? key,
    this.profileImage,
    this.name,
    this.time,
    this.projectName,
    this.feedback,
    this.rating = 0.0,
  }) : super(key: key);

  String? profileImage, name, time, projectName, feedback;
  double? rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: RadiusHandler.radius100,
              child: Image.asset(
                '$profileImage',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: MyText(
              text: '$name',
              size: 16,
              weight: FontWeight.w500,
            ),
            subtitle: MyText(
              text: '$time',
              color: kDarkPurpleColor,
              size: 10,
            ),
          ),
          Row(
            children: [
              Container(
                width: 55,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: '$projectName',
                      size: 18,
                      color: kSecondaryColor,
                      weight: FontWeight.w500,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: RatingBarIndicator(
                        rating: rating!,
                        itemBuilder: (context, index) => Image.asset(
                          kStarIcon,
                          height: 12,
                          color: kYellowColor,
                        ),
                        unratedColor: const Color(0xffEEEEFF),
                        itemCount: 5,
                        itemSize: 12.0,
                        itemPadding: const EdgeInsets.only(right: 4.5),
                        direction: Axis.horizontal,
                      ),
                    ),
                    MyText(
                      text: '$feedback',
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          customDivider,
        ],
      ),
    );
  }
}
