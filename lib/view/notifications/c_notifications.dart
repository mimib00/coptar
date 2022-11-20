import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/notification_controller.dart';
import 'package:copter/Controllers/tasks_controller.dart';
import 'package:copter/Models/notification.dart';
import 'package:copter/Models/user_model.dart';
import 'package:copter/view/chat/chat_screen.dart';
import 'package:copter/view/company/task_dash_board/task_dash_board.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CNotifications extends GetView<NotificationController> {
  const CNotifications({Key? key}) : super(key: key);

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
              if (notification.id == null) return;
              final snap = await notification.id!.get();
              if (!snap.exists) return;
              switch (notification.type) {
                case NotificationType.task:
                  final task = snap.data()!;

                  Get.find<TaskController>().selectedTask = notification.id;

                  int totalCompleted = 0;
                  for (Map<String, dynamic> task in task["tasks"]) {
                    if (task['isCompleted']) {
                      totalCompleted++;
                    }
                  }

                  Get.to(
                    () => TaskDashBoard(
                      uid: snap.id,
                      projectTitle: task["title"],
                      urgentProject: task["type"] == "Urgent",
                      indicatorProgress: totalCompleted / task["tasks"].length,
                    ),
                  );
                  break;

                case NotificationType.chat:
                  final id = notification.id!.parent.parent!.id;
                  final user = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(id)
                      .withConverter(
                        fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot),
                        toFirestore: (value, options) => {},
                      )
                      .get();

                  Get.to(() => ChatScreen(employeModel: user.data()));
                  break;
              }
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
    );
  }
}
