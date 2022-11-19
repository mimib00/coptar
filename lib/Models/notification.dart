import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum NotificationType {
  task,
  chat;

  const NotificationType();

  factory NotificationType.setType(String type) {
    switch (type) {
      case "task":
        return NotificationType.task;
      case "chat":
        return NotificationType.chat;
      default:
        return NotificationType.task;
    }
  }
}

class NotificationModel {
  final String uid;
  final String title;
  final String body;
  final Timestamp createdAt;
  final bool read;
  final NotificationType? type;
  final DocumentReference<TaskModel>? task;

  NotificationModel(
    this.uid,
    this.title,
    this.body,
    this.createdAt,
    this.read,
    this.task,
    this.type,
  );
  factory NotificationModel.fromJson(DocumentSnapshot<Map<String, dynamic>> data) {
    DocumentReference<TaskModel>? ref = data.data()!["task"].toString().isEmpty
        ? null
        : FirebaseFirestore.instance.doc(data.data()!["task"].toString()).withConverter(
              fromFirestore: (snapshot, options) => TaskModel.fromJson({...snapshot.data()!}),
              toFirestore: (value, options) => {},
            );

    return NotificationModel(
      data.id,
      data.data()!["title"],
      data.data()!["body"],
      data.data()!["created_at"],
      data.data()!["read"],
      ref,
      data.data()!["type"] == null ? null : NotificationType.setType(data.data()!["type"]),
    );
  }

  Future<void> markRead() async {
    try {
      final current = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(current.uid)
          .collection("notifications")
          .doc(uid)
          .update({"read": true});
    } on FirebaseException catch (e) {
      log(e.code);
    }
  }
}
