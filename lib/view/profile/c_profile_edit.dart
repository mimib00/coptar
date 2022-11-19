import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
