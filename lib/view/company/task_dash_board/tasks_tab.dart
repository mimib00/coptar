/*import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
import 'package:copter/controller/login_controller/login_controller.dart';*/
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/tasks_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              left: 15,
              right: 15,
              top: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  weight: FontWeight.w500,
                  text: 'Task to do',
                ),
                // Get.find<UserController>().userType == 'company'
                //     ? Image.asset(
                //         kAddIcon,
                //         height: 30,
                //       )
                //     : SizedBox(),
              ],
            ),
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance.doc((taskController.selectedTask?.path).toString()).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: MyText(
                              text: 'No Task',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                var data = snapshot.data!;
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // var data = controller.getTasks[index];
                        return tasksTiles(data["tasks"][index], index);
                        /* data.taskName!,
                      data.isSelected!,
                      index,*/
                      },
                      childCount: data["tasks"].length,
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }
}

Widget tasksTiles(Map<String, dynamic> task, int index) {
  TaskController taskController = Get.find();
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: RadiusHandler.radius10,
      color: kPrimaryColor,
      boxShadow: [
        BoxShadow(
          offset: const Offset(2, 2),
          color: kBlackColor.withOpacity(0.04),
          blurRadius: 6,
        ),
      ],
    ),
    child: Row(
      children: [
        // Checkbox(
        //      value: taskController.tasks.value[taskController.selectedTask]['isCompleted'],
        //      onChanged: (value) {
        //        controller.selectTasksToDo(taskName, isSelected, index);
        //      },
        //      activeColor: kSecondaryColor,
        //      checkColor: kPrimaryColor,
        //      side: const BorderSide(
        //        color: kSecondaryColor,
        //        width: 2.0,
        //      ),
        //    ),
        Checkbox(
          activeColor: kSecondaryColor,
          checkColor: kPrimaryColor,
          value: task['isCompleted'],
          onChanged: (value) async {
            // isSelected = value!;

            String path = taskController.selectedTask!.path;
            var snap = await FirebaseFirestore.instance.doc(path).get();

            var data = snap.data()!;
            try {
              var tasks = data['tasks'];

              tasks[index]['isCompleted'] = value;
              int totalCompleted = 0;
              for (Map<String, dynamic> value in tasks) {
                if (value['isCompleted'] == true) {
                  totalCompleted++;
                }
              }
              String status = 'running';

              double indicatorProgress = totalCompleted / tasks.length;

              if (indicatorProgress == 1) {
                status = 'completed';
              } else if (indicatorProgress == 0) {
                status = 'starting';
              }

              await FirebaseFirestore.instance.doc(path).update({'tasks': tasks.toList(), 'status': status});
            } on FirebaseException catch (e) {
              log(e.code);
            }
          },
          side: const BorderSide(
            color: kSecondaryColor,
            width: 2.0,
          ),
        ),
        Expanded(
          flex: 8,
          child: MyText(
            text: task['task'],
            color: kBlackColor2,
            paddingRight: 15,
          ),
        ),
      ],
    ),
  );
}
