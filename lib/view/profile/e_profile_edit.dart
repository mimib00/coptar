import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/user_controller.dart';

class EProfileEdit extends StatefulWidget {
  const EProfileEdit({Key? key}) : super(key: key);

  @override
  State<EProfileEdit> createState() => _EProfileEditState();
}

class _EProfileEditState extends State<EProfileEdit> {
  UserController userController = Get.put(UserController());
  TextEditingController nameController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: RadiusHandler.radius100,
                    child: Image.asset(
                      'assets/images/dummy_chat/user.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Image.asset(
                      kAddButtonIcon,
                      height: 18,
                    ),
                  ),
                ],
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
              controller: nameController,
              hintText: userController.name.value,
            ),
            CustomTextField(
              labelText: 'Your tagline',
              controller: taglineController,
              hintText: userController.tagline.value,
            ),
            CustomTextField(
              labelText: 'Your email address',
              controller: emailController,
              hintText: userController.email.value,
            ),
            CustomTextField(
              labelText: 'Your password',
              controller: passwordController,
              hintText: '**********',
              obSecure: true,
              haveSuffixIcon: true,
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
                    await userController.updateEmaolyeName(nameController.text);
                    nameController.clear();
                  }
                  if (taglineController.text.isNotEmpty) {
                    await userController.updateEmaolyeTagline(taglineController.text);
                    taglineController.clear();
                  }
                  if (emailController.text.isNotEmpty) {
                    if (_formKey.currentState!.validate()) {
                      await userController.updateEmaolyeEmail(emailController.text);
                      emailController.clear();
                    }
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
