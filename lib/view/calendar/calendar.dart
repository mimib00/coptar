import 'package:copter/Controllers/calander_controller.dart';
import 'package:copter/Models/taskModel.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/calendar.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Calendar extends GetView<CalanderController> {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calender',
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: defaultPadding,
        shrinkWrap: true,
        children: [
          const CalendarWidget(),
          MyText(
            text: 'Your task',
            size: 18,
            weight: FontWeight.w500,
          ),
          const SizedBox(
            height: 30,
          ),
          Obx(
            () {
              controller.selectedDate.value;
              return FutureBuilder<List<TaskModel>>(
                future: controller.getDateTasks(),
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      int totalCompleted = 0;
                      for (Map<String, dynamic> task in task.tasks) {
                        if (task['isCompleted']) {
                          totalCompleted++;
                        }
                      }
                      return TasKWidget(
                        taskRef: task.taskId,
                        projectTitle: task.title,
                        urgentProject: task.type == "Urgent",
                        personsWorking: task.personWorking,
                        timeLeft: task.end.toDate().difference(DateTime.now()).inDays.toString(),
                        indicatorProgress: totalCompleted / task.tasks.length,
                      );
                    },
                  );
                },
              );
            },
          )
          // ListView.builder(
          //   padding: EdgeInsets.zero,
          //   shrinkWrap: true,
          //   itemCount: 6,
          //   itemBuilder: (context, int index) {
          // return TasKWidget(
          //   projectTitle: 'Project Title',
          //   indicatorProgress: 0.5,
          //   urgentProject: false,
          //   personsWorking: 5,
          //   timeLeft: '4 hours,56 mins',
          // );
          //   },
          // )
        ],
        /* ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
             //   itemCount: controller.getAllTasks.length,
              itemCount: 6,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                //  var data = controller.getAllTasks[index];
                  */ /*return TasKWidget(
                    projectTitle: data.projectTitle,
                    urgentProject: data.urgentProject,
                    personsWorking: data.personsWorking,
                    timeLeft: data.timeLeft,
                    indicatorProgress: data.indicatorProgress,
                  );*/ /*
                },
              ),*/
      ),
    );
  }
}
