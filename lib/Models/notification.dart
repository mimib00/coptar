import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final NotificationType type;
  final DocumentReference<Map<String, dynamic>>? id;

  NotificationModel(
    this.uid,
    this.title,
    this.body,
    this.createdAt,
    this.read,
    this.id,
    this.type,
  );
  factory NotificationModel.fromJson(DocumentSnapshot<Map<String, dynamic>> data) {
    DocumentReference<Map<String, dynamic>>? ref = data.data()!["id"] == null || data.data()!["id"].toString().isEmpty
        ? null
        : FirebaseFirestore.instance.doc("${data.data()!["id"]}");
    FirebaseFirestore.instance.collection("MP/tasks/tasks/");

    return NotificationModel(
      data.id,
      data.data()!["title"],
      data.data()!["body"],
      data.data()!["created_at"],
      data.data()!["read"],
      ref,
      NotificationType.setType(data.data()!["type"]),
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
