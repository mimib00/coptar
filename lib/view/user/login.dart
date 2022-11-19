/*
import 'package:copter/controller/login_controller/login_controller.dart';
*/
import 'package:copter/Controllers/loginController.dart';
import 'package:copter/routes/routes.dart';
import 'package:copter/view/root.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final LoginController loginController = Get.put(LoginController());

  //create validator
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //add validator

        body: Form(
          key: _formKey,
          child: Padding(
            padding: defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Center(
                  child: Image.asset(
                    kLogo,
                    height: 108,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      hintText: 'example@gmail.com',
                      controller: loginController.emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        } else if (!loginController.validateEmail()) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      keyboardType: TextInputType.visiblePassword,
                      labelText: 'Password',
                      hintText: '**********',
                      controller: loginController.passwordController,
                      obSecure: true,
                      bottomPadding: 40,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return "Please enter a valid password";
                        }
                        return null;
                      },
                    ),
                    MyButton(
                      onPressed: () {
                        // Get.offAll(() => Root());
                        if (_formKey.currentState!.validate()) {
                          loginController.login();
                        }
                      },
                      text: 'Sign In',
                      textSize: 14,
                      haveRoundedEdges: true,
                    ),
                  ],
                ),
                Container(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: kPrimaryColor,
          child: SizedBox(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(AppLinks.signup),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: kBlackColor2,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: 'Don’t have any account ? ',
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
