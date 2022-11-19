import 'package:copter/Controllers/login_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final loginController = Get.find<LoginController>();

  bool termsAccepted = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /*return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (signUpController) {*/
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              MyText(
                paddingTop: 40,
                paddingBottom: 45,
                text: 'Sign Up',
                size: 24,
                weight: FontWeight.w500,
                color: kSecondaryColor,
                align: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    MyTextField(
                      labelText: 'Name',
                      hintText: 'John smith',
                      controller: loginController.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
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
                      labelText: 'Phone',
                      hintText: '+91 15549416462',
                      keyboardType: TextInputType.phone,
                      controller: loginController.phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      labelText: 'Company type',
                      hintText: 'DesignTeam',
                      controller: loginController.companyTypeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter company type';
                        }
                        return null;
                      },
                    ),
                    MyTextField(
                      labelText: 'Password',
                      hintText: '**********',
                      keyboardType: TextInputType.visiblePassword,
                      controller: loginController.passwordController,
                      obSecure: true,
                      bottomPadding: 40,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: kSecondaryColor,
                    checkColor: kPrimaryColor,
                    value: termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        termsAccepted = !termsAccepted;
                      });
                    },
                    side: BorderSide(
                      color: termsAccepted ? kSecondaryColor : kRedColor,
                      width: 2.0,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: MyText(
                      text: 'I accept terms and conditions',
                      color: termsAccepted ? kBlackColor2 : kRedColor,
                      paddingRight: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (termsAccepted) SignUpButton(formKey: _formKey, loginController: loginController),
              SizedBox(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: kBlackColor2,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: 'Already have an account ? ',
                            ),
                            TextSpan(
                              text: 'Sign in',
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
            ],
          ),
        ),
        // bottomNavigationBar: BottomAppBar(
        //   elevation: 0,
        //   color: kPrimaryColor,
        //   child: SizedBox(
        //     height: 90,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         GestureDetector(
        //           onTap: () => Get.back(),
        //           child: RichText(
        //             text: const TextSpan(
        //               style: TextStyle(
        //                 color: kBlackColor2,
        //                 fontFamily: 'Poppins',
        //               ),
        //               children: [
        //                 TextSpan(
        //                   text: 'Already have an account ? ',
        //                 ),
        //                 TextSpan(
        //                   text: 'Sign in',
        //                   style: TextStyle(
        //                     color: kSecondaryColor,
        //                     fontWeight: FontWeight.w500,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.loginController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MyButton(
        onPressed: () {
          // Get.offNamed(AppLinks.root);
          //default get loading dialog
          Get.defaultDialog(
            title: 'Loading',
            barrierDismissible: false,
            content: const CircularProgressIndicator(
              color: kSecondaryColor,
            ),
          );
          if (_formKey.currentState!.validate()) {
            loginController.signUp();
          }

          //close get dialog
          Navigator.of(Get.overlayContext!).pop();
        },
        text: 'Sign Up',
        textSize: 14,
        haveRoundedEdges: true,
      ),
    );
  }
}
