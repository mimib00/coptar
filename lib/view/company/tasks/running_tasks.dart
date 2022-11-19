import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/tasks_controller.dart';

class RunningTasks extends StatelessWidget {
  const RunningTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* return GetBuilder<TaskController>(
      init: TaskController(),
      builder: (controller) {*/
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Running Task',
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
                  itemCount: taskController.runningTasks.value.length,
                  itemBuilder: (context, int index) {
                    var task = taskController.runningTasks.value[index];

                    int totalCompleted = 0;
                    for (Map<String, dynamic> task in task.tasks) {
                      if (task['isCompleted']) {
                        totalCompleted++;
                      }
                    }
                    return TasKWidget(
                      taskRef: task.taskId,
                      taskList: 'running',
                      taskIndex: index,
                      projectTitle: task.title,
                      urgentProject: task.type == "Urgent",
                      personsWorking: 2,
                      timeLeft: task.end.toDate().difference(DateTime.now()).inDays.toString(),
                      indicatorProgress: totalCompleted / task.tasks.length,
                    );
                  },
                );
        },
      ),
    );
  }
}
