import 'package:cached_network_image/cached_network_image.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/profile_resuable_widgets.dart';
import 'package:copter/view/widget/review_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PublicProfileDetail extends StatelessWidget {
  const PublicProfileDetail({
    Key? key,
    this.profileImage,
    this.name,
    this.status,
  }) : super(key: key);

  final String? profileImage, name, status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile review',
      ),
      body: ListView(
        padding: defaultPadding,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ClipRRect(
              borderRadius: RadiusHandler.radius100,
              child: profileImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: CachedNetworkImage(
                        imageUrl: profileImage!,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(Icons.person_rounded),
                        ),
                      ),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.person_rounded),
                    ),
            ),
          ),
          MyText(
            paddingTop: 20,
            align: TextAlign.center,
            text: '$name',
            size: 16,
            weight: FontWeight.w500,
          ),
          MyText(
            align: TextAlign.center,
            text: '$status',
            size: 12,
          ),
          const SizedBox(
            height: 15,
          ),
          customDivider,
          const SizedBox(
            height: 20,
          ),
          ProgressBars(
            title: 'Active',
            indicatorProgress: 1.0,
          ),
          ProgressBars(
            title: 'Task Performance',
            indicatorProgress: 1.0,
          ),
          ProgressBars(
            title: 'Quality',
            indicatorProgress: 1.0,
          ),
          const SizedBox(
            height: 15,
          ),
          customDivider,
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return ReviewWidget(
                profileImage: 'assets/images/dummy_chat/user.png',
                name: 'Wilson Mango',
                time: '15 January 2022',
                projectName: 'Create a App Design',
                rating: index.isEven ? 5.0 : 2.0,
                feedback: 'Lorem Ipsum is simply dummy text of the printing industry\'s standard dummy text',
              );
            },
          ),
        ],
      ),
    );
  }
}
