//create user controller getx

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//create getx login controller
class UserController extends GetxController {
  final dio = Dio();

  Rx<String> uid = ''.obs;
  Rx<String> email = ''.obs;
  Rx<String> name = ''.obs;
  Rx<String> phone = ''.obs;
  Rx<String> photo = ''.obs;
  Rx<String> userType = ''.obs;
  Rx<String> companyType = ''.obs;
  Rx<String> tagline = ''.obs;

  RxList<UserModel> employeList = <UserModel>[].obs;
  RxList<UserModel> dummyEmploye = <UserModel>[].obs;

  Future<double?> getTaskPerformance({String? id}) async {
    try {
      final docs =
          await FirebaseFirestore.instance.collection(companyType.value).doc("tasks").collection("tasks").get();
      List myTasks = [];
      int total = 0;
      for (var doc in docs.docs) {
        final snap = await FirebaseFirestore.instance
            .collection(companyType.value)
            .doc("tasks")
            .collection("tasks")
            .doc(doc.id)
            .collection("users")
            .where("userId", isEqualTo: id ?? uid.value)
            .get();

        if (snap.docs.isNotEmpty) {
          total += 1;
          myTasks.add(doc.data());
        }
      }

      final unDone = myTasks.where((element) => element["status"] == "completed").length;
      return unDone == 0 ? 0 : (total / unDone) / unDone;
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message ?? "");
      return null;
    }
  }

  Future<void> updateFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      final current = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection("users").doc(current.uid).update({"token": token});
    } on FirebaseException catch (e) {
      log(e.code);
      Get.snackbar("Error", e.code);
    }
  }

  Future<void> startUserDataStream() async {
    await updateFCMToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('users').doc(uid.value).snapshots().listen((event) {
      name.value = event.data()!['name'];
      email.value = event.data()!['email'];
      phone.value = event.data()!['phone'];
      userType.value = event.data()!['type'];
      companyType.value = event.data()!['companyType'];
      tagline.value = event.data()!['tagline'];
      photo.value = event.data()!['photo'] ?? '';

      prefs.setString('email', email.value);
      prefs.setString('name', name.value);
      prefs.setString('phone', phone.value);
      prefs.setString('userType', userType.value);
      prefs.setString('companyType', companyType.value);
      prefs.setString('tagline', tagline.value);
      prefs.setString('photo', photo.value);
    });
  }

  ///////////////////////////////////////////
  Future<void> updateEmaolyeName(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "name": text,
      });

      name.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('name', name.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateEmaolyeTagline(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "tagline": text,
      });

      tagline.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('tagline', tagline.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateEmaolyeEmail(String text) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateEmail(text);

      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "email": text,
      });
      email.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('email', email.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateEmpolyePassword(String text) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(text);

      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "password": text,
      });

      FirebaseFirestore.instance.doc("users/$uid").update({
        "password": text,
      });
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  ///////////////////////////////////////////

  Future<void> updateUserName(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection(uid.value)
          .doc("info")
          .update({
        "name": text,
      });
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "name": text,
      });

      name.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('name', name.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateUserTagline(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection(uid.value)
          .doc("info")
          .update({
        "tagline": text,
      });
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "tagline": text,
      });

      tagline.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('tagline', tagline.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateUserEmail(String text) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateEmail(text);

      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "email": text,
      });

      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection(uid.value)
          .doc("info")
          .update({
        "email": text,
      });
      email.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('email', email.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateUserPhone(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection(uid.value)
          .doc("info")
          .update({
        "phone": text,
      });

      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection("users")
          .doc(uid.value)
          .update({
        "phone": text,
      });

      phone.value = text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('phone', phone.value);
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> updateUserPassword(String text) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(text);

      await FirebaseFirestore.instance
          .collection(companyType.value)
          .doc("users")
          .collection(uid.value)
          .doc("info")
          .update({
        "password": text,
      });

      FirebaseFirestore.instance.doc("users/$uid").update({
        "password": text,
      });
    } on Exception catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> generateEmployeeAccounts({required int numberOfEmployeesToGenerate}) async {
    try {
      const url = "https://us-central1-copter-439c8.cloudfunctions.net/createEmployees";
      await dio.post(url, data: {
        "num": numberOfEmployeesToGenerate,
        "company": companyType.value,
      });
    } on DioError catch (e) {
      Get.back();
      log(e.message);
      Get.snackbar("Error", e.message);
    }
  }

  Future<List<UserModel>> getEmployess() async {
    try {
      final current = FirebaseAuth.instance.currentUser!;
      final user = await FirebaseFirestore.instance.collection("users").doc(current.uid).get();
      log(current.uid.toString());
      if (!user.exists) return [];
      final type = user.data()!["companyType"];

      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where("companyType", isEqualTo: type)
          .where("type", isEqualTo: "employee")
          .get();
      List<UserModel> users = [];
      for (var user in snap.docs) {
        users.add(UserModel.fromJson(user));
      }

      employeList.value =
          UserModel.jsonToListView(snap.docs).where((element) => element.userId != current.uid).toList();

      return users;
    } on FirebaseException catch (e) {
      log(e.code);
      Get.snackbar(
        "Error",
        e.code,
      );
      return [];
    } catch (e, stakcTrace) {
      debugPrintStack(stackTrace: stakcTrace);
      log(e.toString());

      return [];
    }

    // print(data.docs.length);
    // for (var employee in data.docs) {
    //   print(employee.data());
    // }
  }
}
