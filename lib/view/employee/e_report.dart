import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/review_widget.dart';
import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Report',
      ),
      body: ListView.builder(
        padding: defaultPadding,
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
            feedback:
                'Lorem Ipsum is simply dummy text of the printing industry\'s standard dummy text',
          );
        },
      ),
    );
  }
}
