/*
import 'package:copter/controller/notification_controller/notification_controller.dart';
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/tasksController.dart';
import 'package:copter/Models/notification.dart';
import 'package:copter/view/company/task_dash_board/task_dash_board.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/notification_tiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ENotifications extends StatelessWidget {
  const ENotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = FirebaseAuth.instance.currentUser!;
    final query = FirebaseFirestore.instance
        .collection("users")
        .doc(current.uid)
        .collection("notifications")
        .where("read", isEqualTo: false)
        .withConverter(
          fromFirestore: (snapshot, options) => NotificationModel.fromJson(snapshot),
          toFirestore: (value, options) => {},
        );
    return Scaffold(
      appBar: const CustomAppBarWithLogo(),
      body: FirestoreListView<NotificationModel>(
        physics: const BouncingScrollPhysics(),
        query: query,
        itemBuilder: (context, doc) {
          final notification = doc.data();
          return ListTile(
            onTap: () async {
              if (notification.task == null) return;
              final snap = await notification.task!.get();
              if (!snap.exists) return;
              final task = snap.data()!;

              Get.find<TaskController>().selectedTask = notification.task;

              int totalCompleted = 0;
              for (Map<String, dynamic> task in task.tasks) {
                if (task['isCompleted']) {
                  totalCompleted++;
                }
              }

              Get.to(
                () => TaskDashBoard(
                  uid: snap.id,
                  projectTitle: task.title,
                  urgentProject: task.type == "Urgent",
                  indicatorProgress: totalCompleted / task.tasks.length,
                ),
              );
            },
            isThreeLine: true,
            leading: const CircleAvatar(
              backgroundColor: kPurpleColor,
              foregroundColor: Colors.white,
              child: Icon(Icons.notifications_rounded),
            ),
            title: MyText(text: notification.title, size: 12),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: notification.body, size: 12),
                MyText(
                  text: DateFormat("hh:mm a").format(notification.createdAt.toDate()),
                  size: 9,
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () => notification.markRead(),
              icon: const Icon(Icons.close_rounded),
            ),
          );
        },
      ),
      //   body: ListView.builder(
      //   shrinkWrap: true,
      //   padding: const EdgeInsets.only(
      //     left: 15,
      //     right: 15,
      //     bottom: 60,
      //     top: 20,
      //   ),
      //   physics: const BouncingScrollPhysics(),
      //   //itemCount: controller.getDummyEmployeeNotifications.length,
      //     itemCount: 7,
      //   itemBuilder: (context, index) {
      //     //var data = controller.getDummyEmployeeNotifications[index];
      //     return NotificationTiles(
      //       msg: "Create a mobile app has been updated by you",
      //       time:"10 Jan, 2022 | 10.36 am",
      //       requestToJoin: true,
      //     );
      //   },
      // ),
    );
  }
}
