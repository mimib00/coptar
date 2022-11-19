import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/userController.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/back_button.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GetEmployeeAccount extends StatefulWidget {
  const GetEmployeeAccount({Key? key}) : super(key: key);

  @override
  State<GetEmployeeAccount> createState() => _GetEmployeeAccountState();
}

class _GetEmployeeAccountState extends State<GetEmployeeAccount> {
  int _employessToCreate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 60,
              centerTitle: true,
              pinned: true,
              leading: backButton(),
              title: MyText(
                text: 'Employee account',
                weight: FontWeight.w500,
                color: kBlackColor2,
                size: 14,
              ),
              expandedHeight: 210,
              flexibleSpace: ListView(
                padding: const EdgeInsets.only(top: 120),
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    title: MyText(
                      text: 'Total Employees to create',
                      weight: FontWeight.w500,
                    ),
                    trailing: Container(
                      width: 112,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: RadiusHandler.radius10,
                        color: kSecondaryColor.withOpacity(0.1),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _employessToCreate > 0
                                    ? _employessToCreate--
                                    : null;
                              });
                            },
                            child: Image.asset(
                              'assets/images/decreament.png',
                              height: 24,
                            ),
                          ),
                          MyText(
                            text: _employessToCreate.toString(),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _employessToCreate++;
                              });
                            },
                            child: Image.asset(
                              'assets/images/increament.png',
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: Get.width * 0.8,
                      child: MyButton(
                        onPressed: () async {
                          if (_employessToCreate > 0) {
                            Get.defaultDialog(
                              title: 'Generating Employee Accounts',
                              content: const CircularProgressIndicator(
                                color: kSecondaryColor,
                              ),
                              barrierDismissible: false,
                            );
                            await Get.find<UserController>()
                                .generateEmployeeAccounts(
                                    numberOfEmployeesToGenerate:
                                        _employessToCreate);
                            Get.back();
                            Get.snackbar("Success",
                                "$_employessToCreate Employee accounts generated");
                            setState(() {
                              _employessToCreate = 0;
                            });
                          } else {
                            Get.snackbar("Error",
                                "The number of employees to create must be greater than 0");
                          }
                        },
                        text: 'Generate employee',
                        haveCustomElevation: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MultiSliver(
              children: [
                SliverPinnedHeader(
                  child: Container(
                    height: 50,
                    color: kPrimaryColor,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: 'Previous employee',
                        weight: FontWeight.w500,
                        paddingLeft: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("companyType",
                  isEqualTo: Get.find<UserController>().companyType.value)
              .where("type", isEqualTo: "employee")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: snapshot.data.docs.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var data = snapshot.data.docs[index];

                  return PreviousEmployeesTiles(
                    email: data['email'],
                    password: data['password'],
                  );
                },
              );
            } else {
              return Center(
                child: MyText(
                  text: "No previous employee",
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PreviousEmployeesTiles extends StatelessWidget {
  PreviousEmployeesTiles({
    Key? key,
    this.email,
    this.password,
  }) : super(key: key);

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: RadiusHandler.radius10,
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.04),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListTile(
        title: MyText(
          text: 'Email : $email',
          size: 12,
        ),
        subtitle: MyText(
          text: 'Password : $password',
          size: 12,
        ),
        trailing: GestureDetector(
          onTap: () async {
            print("copy pressed");
            await Clipboard.setData(
                ClipboardData(text: "email : $email\npassword : $password"));
            Get.snackbar("Success", "Details copied to clipboard");
          },
          child: Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: kSecondaryColor.withOpacity(0.1),
            ),
            child: Center(
              child: MyText(
                text: 'copy',
                color: kSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
