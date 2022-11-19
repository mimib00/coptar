/*
import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
*/
import 'package:copter/Controllers/tasksController.dart';
import 'package:copter/view/company/tasks/cancel_tasks.dart';
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

import '../root.dart';

class EHome extends StatelessWidget {
  EHome({Key? key}) : super(key: key);

  TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithLogo(),
      body: Obx(
          () => ListView(padding: defaultPadding, shrinkWrap: true, physics: const BouncingScrollPhysics(), children: [
                MyText(
                  text: 'My Task',
                  size: 18,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: '10 Jan, 2022',
                  size: 12,
                  color: kDarkPurpleColor,
                  paddingBottom: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: dashBoardTiles(
                        'Starting',
                        taskController.allTasks.value.where((element) => element.status == "starting").length,
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
                        taskController.allTasks.value.where((element) => element.status == "running").length,
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
                        taskController.allTasks.value.where((element) => element.status == "completed").length,
                        kGreenColor,
                        () => Get.to(() => const CompletedTasks()),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: dashBoardTiles(
                        'Cancel',
                        taskController.allTasks.value.where((element) => element.status == "cancel").length,
                        kRedColor,
                        () => Get.to(() => const CancelTasks()),
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
                GetX(
                  init: Get.put<TaskController>(TaskController()),
                  builder: (TaskController taskController) {
                    return (taskController.allTasks.value.isEmpty || taskController.allTasks.value == null)
                        ? Center(
                            child: MyText(
                              text: 'No task available',
                              size: 18,
                              weight: FontWeight.w500,
                              color: kLightPurpleColor,
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: taskController.allTasks.value.length,
                            itemBuilder: (context, int index) {
                              var task = taskController.allTasks.value[index];

                              int total_completed = 0;
                              for (Map<String, dynamic> task in task.tasks) {
                                if (task['isCompleted']) {
                                  total_completed++;
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
                                indicatorProgress: total_completed / task.tasks.length,
                              );
                            });
                  },
                ),
                // ListView.builder(
                //     padding: EdgeInsets.zero,
                //     shrinkWrap: true,
                //     itemCount: taskController.allTasks.value.length,
                //     itemBuilder: (context, int index) {
                //       var data = taskController.allTasks.value[index];
                //       return TasKWidget(
                //         projectTitle: data.title,
                //         indicatorProgress:  data.tasks[0]["isCompleted"],
                //         urgentProject:  data.type=="Ongoing"?false:true,
                //         personsWorking:  2,
                //         timeLeft:  data.title,
                //       );
                //     }),
                const SizedBox(
                  height: 60,
                ),
              ])),
      //bottomNavigationBar: Root(),
    );
  }
}
