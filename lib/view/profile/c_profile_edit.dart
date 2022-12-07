import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/my_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CProfileEdit extends StatefulWidget {
  const CProfileEdit({Key? key}) : super(key: key);

  @override
  State<CProfileEdit> createState() => _CProfileEditState();
}

class _CProfileEditState extends State<CProfileEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserController userController = Get.put(UserController());

  final picker = ImagePicker();

  //create global form key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: defaultPadding,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  final image = await picker.pickImage(source: ImageSource.gallery);
                  if (image == null) return;
                  Get.defaultDialog(
                    title: 'Please wait',
                    content: const CircularProgressIndicator(color: kSecondaryColor),
                    barrierDismissible: false,
                  );
                  final UserController user = Get.find();
                  final storage = FirebaseStorage.instance.ref();
                  final snap =
                      await storage.child('profile/${user.uid}/${DateTime.now().microsecondsSinceEpoch}').putFile(
                            File(image.path),
                            SettableMetadata(
                              contentType: "image/jpeg",
                            ),
                          );
                  if (snap.state == TaskState.error || snap.state == TaskState.canceled) {
                    throw "There was an error during upload";
                  }
                  final url = await snap.ref.getDownloadURL();

                  await FirebaseFirestore.instance.collection("users").doc(user.uid.value).update({"photo": url});
                  Get.back();
                  Get.back();
                } on FirebaseException catch (e) {
                  Get.back();
                  log(e.code);
                }
              },
              child: Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: RadiusHandler.radius100,
                      child: CachedNetworkImage(
                        imageUrl: userController.photo.value,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(Icons.person_rounded),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: Get.width * .09,
                      child: Image.asset(
                        kAddButtonIcon,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MyText(
              text: 'Change profile picture',
              align: TextAlign.center,
              paddingTop: 15.0,
              paddingBottom: 40.0,
            ),
            CustomTextField(
              labelText: 'Your name',
              hintText: userController.name,
              controller: nameController,
            ),
            CustomTextField(
              labelText: 'Your tagline',
              hintText: userController.tagline,
              controller: taglineController,
            ),
            CustomTextField(
              labelText: 'Your email address',
              hintText: userController.email,
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            CustomTextField(
              labelText: 'Your phone number',
              hintText: userController.phone,
              controller: phoneController,
            ),
            CustomTextField(
              labelText: 'Your password',
              hintText: '**********',
              obSecure: true,
              haveSuffixIcon: true,
              controller: passwordController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Center(
            child: SizedBox(
              width: Get.width * 0.8,
              child: MyButton(
                haveCustomElevation: true,
                onPressed: () async {
                  Get.defaultDialog(
                    title: 'Updating...',
                    content: const CircularProgressIndicator(),
                  );

                  if (nameController.text.isNotEmpty) {
                    await userController.updateUserName(nameController.text);
                    nameController.clear();
                  }
                  if (taglineController.text.isNotEmpty) {
                    await userController.updateUserTagline(taglineController.text);
                    taglineController.clear();
                  }
                  if (emailController.text.isNotEmpty) {
                    if (_formKey.currentState!.validate()) {
                      await userController.updateUserEmail(emailController.text);
                      emailController.clear();
                    }
                  }
                  if (phoneController.text.isNotEmpty) {
                    await userController.updateUserPhone(phoneController.text);
                    phoneController.clear();
                  }
                  if (passwordController.text.isNotEmpty) {
                    await userController.updateUserPassword(passwordController.text);
                    passwordController.clear();
                  }

                  Get.back();
                  Get.back();
                },
                text: 'Save profile',
                textSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
