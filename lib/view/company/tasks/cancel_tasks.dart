/*
import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
*/
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelTasks extends StatelessWidget {
  const CancelTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return GetBuilder<TaskController>(
      init: TaskController(),
      builder: (controller) {*/
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Cancel Task',
          ),
        /*  body: controller.getCancelTasks.isEmpty
              ?
          */
          body : Center(
                  child: MyText(
                    text: 'No task available',
                    size: 18,
                    weight: FontWeight.w500,
                    color: kLightPurpleColor,
                  ),
                )
              /*: ListView.builder(
                  padding: defaultPadding,
                  shrinkWrap: true,
                  //itemCount: controller.getRunningTasks.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                   // var data = controller.getRunningTasks[index];
                    *//*return TasKWidget(
                      projectTitle: data.projectTitle,
                      urgentProject: data.urgentProject,
                      personsWorking: data.personsWorking,
                      timeLeft: data.timeLeft,
                      indicatorProgress: data.indicatorProgress,
                    );*//*
                  },
                ),*/
        );
      }
  }
