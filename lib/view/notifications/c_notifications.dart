import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/notification_controller.dart';
import 'package:copter/Models/notification.dart';
import 'package:copter/Models/userModel.dart';
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
            isThreeLine: true,
            leading: const CircleAvatar(
              backgroundColor: kPurpleColor,
              foregroundColor: Colors.white,
              child: Icon(Icons.notifications_rounded),
            ),
            title: MyText(text: notification.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: notification.body, size: 13),
                MyText(
                  text: DateFormat("hh:mm a").format(notification.createdAt.toDate()),
                  size: 10,
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
