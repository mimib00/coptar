/*import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:get/get.dart';
import 'package:copter/view/widget/my_text.dart';*/

import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/tasks_controller.dart';
import 'package:get/get.dart';

import '../../constant/colors.dart';
import '../../widget/my_text.dart';

class StartingTasks extends StatelessWidget {
  const StartingTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return GetBuilder<TaskController>(
      init: TaskController(),
      builder: (controller) {*/
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Starting Task',
        ),
        body: GetX(
          init: Get.put<TaskController>(TaskController()),
          builder: (TaskController taskController) {
            return taskController.allTasks.value.isEmpty
                ? Center(
                    child: MyText(
                      text: 'No task available',
                      size: 18,
                      weight: FontWeight.w500,
                      color: kLightPurpleColor,
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: taskController.startingTasks.value.length,
                    itemBuilder: (context, int index) {
                      var task = taskController.startingTasks.value[index];

                      int totalCompleted = 0;
                      for (Map<String, dynamic> task in task.tasks) {
                        if (task['isCompleted']) {
                          totalCompleted++;
                        }
                      }
                      return TasKWidget(
                        taskRef: task.taskId,
                        taskList: 'starting',
                        taskIndex: index,
                        projectTitle: task.title,
                        urgentProject: task.type == "starting",
                        personsWorking: 2,
                        timeLeft: task.end.toDate().difference(DateTime.now()).inDays.toString(),
                        indicatorProgress: totalCompleted / task.tasks.length,
                      );
                    });
          },
        )

        // ListView.builder(
        //     padding: EdgeInsets.all(18.0),
        //     shrinkWrap: true,
        //     itemCount: 12,
        //     itemBuilder: (context, int index) {
        //       return
        //
        //         TasKWidget(
        //         projectTitle: 'Project Title',
        //         indicatorProgress: 0.1,  // Value between 0.0 to 1.0
        //         urgentProject: true,
        //         personsWorking: 5,
        //         timeLeft: '4 hours,56 mins',
        //       );
        //     }),
        /*
        Center(
          child: MyText(
            text: 'No task available',
            size: 18,
            weight: FontWeight.w500,
            color: kLightPurpleColor,
          ),
        )
       : ListView.builder(
                  padding: defaultPadding,
                  shrinkWrap: true,
                  itemCount: controller.getAllTasks.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = controller.getAllTasks[index];
                    return TasKWidget(
                      projectTitle: data.projectTitle,
                      urgentProject: data.urgentProject,
                      personsWorking: data.personsWorking,
                      timeLeft: data.timeLeft,
                      indicatorProgress: data.indicatorProgress,
                    );
                  },
                ),*/
        );
  }
}
