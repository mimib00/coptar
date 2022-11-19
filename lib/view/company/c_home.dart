import 'package:copter/Controllers/tasks_controller.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/view/company/tasks/completed_tasks.dart';
import 'package:copter/view/company/tasks/running_tasks.dart';
import 'package:copter/view/company/tasks/starting_tasks.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/dashboard_tiles.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CHome extends StatefulWidget {
  const CHome({Key? key}) : super(key: key);

  @override
  State<CHome> createState() => _CHomeState();
}

class _CHomeState extends State<CHome> {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithLogo(),
      body: GetX(
          init: Get.put<TaskController>(TaskController()),
          builder: (TaskController taskController) {
            return ListView(
              padding: defaultPadding,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                MyText(
                  text: 'My Task',
                  size: 18,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  size: 12,
                  color: kDarkPurpleColor,
                  paddingBottom: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: dashBoardTiles(
                        'Starting',
                        taskController.startingTasks.value.length.toString(),
                        kBlueColor,
                        () => Get.to(() => const StartingTasks()),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: dashBoardTiles(
                        'Running',
                        taskController.runningTasks.value.length.toString(),
                        kYellowColor,
                        () => Get.to(() => const RunningTasks()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: dashBoardTiles(
                        'Completed',
                        taskController.completedTasks.value.length.toString(),
                        kGreenColor,
                        () => Get.to(() => const CompletedTasks()),
                      ),
                    ),
                  ],
                ),
                MyText(
                  text: 'My latest task report',
                  size: 16,
                  weight: FontWeight.w500,
                  paddingTop: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
                taskController.allTasks.value.isEmpty
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
                            personsWorking: task.personWorking,
                            timeLeft: task.end.toDate().difference(DateTime.now()).inDays.toString(),
                            indicatorProgress: totalCompleted / task.tasks.length,
                          );
                        },
                      ),
              ],
            );
          }),
    );
  }
}
