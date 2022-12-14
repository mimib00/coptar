/*
import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
*/
import 'package:copter/Controllers/tasks_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelTasks extends GetView<TaskController> {
  const CancelTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = controller.allTasks.value.where((element) => element.status == "cancel").toList(growable: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cancel Task',
      ),
      body: tasks.isEmpty
          ? Center(
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
              itemCount: tasks.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var task = tasks[index];
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
                  personsWorking: task.personWorking,
                  timeLeft: task.end.toDate().difference(DateTime.now()).inDays.toString(),
                  indicatorProgress: totalCompleted / task.tasks.length,
                );
              },
            ),
    );
  }
}
