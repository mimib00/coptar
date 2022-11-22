import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalanderController extends GetxController {
  Rx<DateTime> selectedDate = Rx(DateTime.now());

  Future<List<TaskModel>> getDateTasks() async {
    try {
      final current = FirebaseAuth.instance.currentUser!;
      final user = await FirebaseFirestore.instance.collection("users").doc(current.uid).get();
      if (!user.exists) return [];
      final type = user.data()!["companyType"];
      final snap = await FirebaseFirestore.instance
          .collection(type)
          .doc("tasks")
          .collection("tasks")
          .where("end", isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate.value))
          .where("status", isEqualTo: "starting")
          .get();

      final List<TaskModel> tasks = [];

      for (var task in snap.docs) {
        tasks.add(TaskModel.fromDocumentSnapshot(task));
      }
      return tasks;
    } on FirebaseException catch (e) {
      log(e.code);
      return [];
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.toString());
      return [];
    }
  }
}
