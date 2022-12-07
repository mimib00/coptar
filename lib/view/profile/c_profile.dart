import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/routes/routes.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/user/login.dart';
import 'package:copter/view/widget/back_button.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/profile_resuable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CProfile extends StatefulWidget {
  const CProfile({Key? key}) : super(key: key);

  @override
  State<CProfile> createState() => _CProfileState();
}

class _CProfileState extends State<CProfile> {
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: backButton(),
          title: Image.asset(
            kLogoSmall,
            height: 40,
          ),
        ),
        body: Obx(() => ListView(
              padding: defaultPadding,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ClipRRect(
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
                ),
                MyText(
                  paddingTop: 20,
                  align: TextAlign.center,
                  text: userController.name.value,
                  size: 16,
                  weight: FontWeight.w500,
                ),
                MyText(
                  align: TextAlign.center,
                  text: userController.companyType.value,
                  size: 12,
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: Get.width * 0.5,
                    child: MyButton(
                      onPressed: () => Get.toNamed(AppLinks.cProfileEdit),
                      text: 'Edit Profile',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ProfileTiles(
                  icon: kMemberShipIcon,
                  iconSize: 17,
                  title: 'Upgrade membership',
                  bgColor: kYellowColor,
                  onTap: () => Get.toNamed(AppLinks.subscription),
                ),
                ProfileTiles(
                  icon: kPersonsGreen,
                  iconSize: 18,
                  title: 'Get employee account',
                  bgColor: kGreenColor,
                  onTap: () => Get.toNamed(AppLinks.getEmployeeAccount),
                ),
                ProfileTiles(
                  icon: kPersonsPurple,
                  iconSize: 18,
                  title: 'View employee profile',
                  bgColor: kSecondaryColor,
                  onTap: () => Get.toNamed(AppLinks.publicProfile),
                ),
                ProfileTiles(
                  icon: kSupportIcon,
                  iconSize: 18,
                  title: 'Support',
                  bgColor: kRedColor,
                  onTap: () {},
                ),
                ProfileTiles(
                  icon: kLogoutIcon,
                  iconSize: 18,
                  title: 'Log out',
                  bgColor: kSecondaryColor,
                  onTap: () async {
                    final current = FirebaseAuth.instance.currentUser!;
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(current.uid)
                        .update({"token": FieldValue.delete()});
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    prefs.setBool("isFirstTime", false);

                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => Login());
                  },
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            )));
  }
}
