import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/user/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/root.dart';

//create getx login controller
class LoginController extends GetxController {
  //create firebase auth instance
  FirebaseAuth auth = FirebaseAuth.instance;
  UserController userController = Get.find();

  //create text editing controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyTypeController = TextEditingController();

  //create getx variable
  var isLoading = false.obs;

  bool validateEmail() {
    RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(emailController.text);
  }

  //create login function
  void login() async {
    try {
      isLoading(true);
      Get.defaultDialog(
        title: 'Please wait',
        content: const CircularProgressIndicator(color: kSecondaryColor),
        barrierDismissible: false,
      );

      await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      await updateDetailsInUserController();

      Get.offAll(() => const Root());
    } catch (e) {
      if (e.toString().split("]").length > 1) {
        Get.snackbar("Error", e.toString().split("]")[1]);
      } else {
        Get.snackbar("Error", e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    try {
      isLoading(true);
      await auth.signOut();

      SharedPreferences.getInstance().then((value) => value.clear());
      Get.offAll(() => Login());
      // Get.offAll(() => Root());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void signUp() async {
    try {
      isLoading(true);
      Get.defaultDialog(
        title: 'Please wait',
        content: const CircularProgressIndicator(
          color: kSecondaryColor,
        ),
        barrierDismissible: false,
      );
      await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'companyType': companyTypeController.text,
        'type': 'company',
        'tagline': ""
      });

      await FirebaseFirestore.instance.collection(companyTypeController.text).doc("users").set({
        "last Updated": Timestamp.now(),
      });

      await FirebaseFirestore.instance
          .collection(companyTypeController.text)
          .doc("users")
          .collection(auth.currentUser!.uid)
          .doc("info")
          .set({
        'email': emailController.text,
        'password': passwordController.text,
        "userId": auth.currentUser!.uid,
      });

      await FirebaseFirestore.instance
          .collection(companyTypeController.text)
          .doc("users")
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set({
        'email': emailController.text,
        'password': passwordController.text,
        "userId": auth.currentUser!.uid,
      });

      userController.uid.value = auth.currentUser!.uid;
      userController.email.value = emailController.text;
      userController.name.value = nameController.text;
      userController.phone.value = phoneController.text;
      userController.userType.value = 'company';
      userController.companyType.value = companyTypeController.text;
      userController.tagline.value = "";

      await updateSharedPref();

      Get.offAll(() => const Root());
    } catch (e) {
      if (e.toString().split("]").length > 1) {
        Get.snackbar("Error", e.toString().split("]")[1]);
      } else {
        Get.snackbar("Error", e.toString());
      }
    } finally {
      isLoading(false);
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

  Future<void> updateDetailsInUserController() async {
    FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid).get().then((value) {
      userController.uid.value = auth.currentUser!.uid;
      userController.email.value = value.data()!['email'];
      userController.name.value = value.data()!['name'];
      userController.phone.value = value.data()!['phone'];
      userController.userType.value = value.data()!['type'];
      userController.companyType.value = value.data()!['companyType'];
      userController.tagline.value = value.data()!['tagline'];
    });

    userController.startUserDataStream();
    await updateSharedPref();
  }

  Future<void> updateSharedPref() async {
    await updateFCMToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('uid', userController.uid.value);
    prefs.setString('email', userController.email.value);
    prefs.setString('name', userController.name.value);
    prefs.setString('phone', userController.phone.value);
    prefs.setString('userType', userController.userType.value);
    prefs.setString('companyType', userController.companyType.value);
    prefs.setString('tagline', userController.tagline.value);
  }
}
