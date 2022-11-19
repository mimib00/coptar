/*
import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
*/

import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/tasks_controller.dart';

class All extends StatelessWidget {
  const All({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* return Center(
                child: MyText(
                  text: 'No task available',
                  size: 18,
                  weight: FontWeight.w500,
                  color: kLightPurpleColor,
                ),
            : ListView(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
            bottom: 70,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: controller.getAllTasks
              .map(
                (e) => TasKWidget(
              projectTitle: e.projectTitle,
              urgentProject: e.urgentProject,
              personsWorking: e.personsWorking,
              timeLeft: e.timeLeft,
              indicatorProgress: e.indicatorProgress,
            ),
          )
            //  .toList(),
    ));*/
    return GetX(
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
                itemCount: taskController.allTasks.value.length,
                itemBuilder: (context, int index) {
                  var task = taskController.allTasks.value[index];

                  int totalCompleted = 0;
                  for (Map<String, dynamic> task in task.tasks) {
                    if (task['isCompleted']) {
                      totalCompleted++;
                    }
                  }
                  return TasKWidget(
                    taskRef: task.taskId,
                    taskList: 'allTasks',
                    taskIndex: index,
                    projectTitle: task.title,
                    urgentProject: task.type == "Urgent",
                    personsWorking: 2,
                    timeLeft: task.end.toDate().difference(DateTime.now()).inDays.toString(),
                    indicatorProgress: totalCompleted / task.tasks.length,
                  );
                });
      },
    );
  }
}
