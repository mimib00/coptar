/*import 'package:copter/controller/company_controller/task_controller/task_controller.dart';*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:copter/Models/user_model.dart';
import 'package:copter/view/chat/add_chat.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/back_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/user_controller.dart';

class InviteEmployee extends GetView<UserController> {
  const InviteEmployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(),
        title: searchBar(controller),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: controller.getEmployess(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            padding: defaultPadding,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final user = users[index];
              return EmployeeItem(
                user: user,
              );
            },
          );
        },
      ),
    );
  }
}

class EmployeeItem extends GetView<UserController> {
  final UserModel user;

  const EmployeeItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 8,
            color: kBlackColor.withOpacity(0.04),
          ),
        ],
      ),
      child: Obx(
        () {
          final selected = controller.dummyEmploye.contains(user);
          return ListTile(
            onTap: () {
              if (selected) {
                controller.dummyEmploye.removeWhere((element) => element.userId == user.userId);
              } else {
                controller.dummyEmploye.add(user);
              }
              controller.update();
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: CachedNetworkImage(
                imageUrl: user.employeImage,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(Icons.person_rounded),
                ),
              ),
            ),
            title: MyText(
              text: user.name,
              weight: FontWeight.w500,
            ),
            subtitle: MyText(
              text: user.email,
              size: 12,
            ),
            trailing: selected
                ? Image.asset(
                    kSelectIcon,
                    height: 16,
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}

// class InviteEmployee extends StatefulWidget {
//   const InviteEmployee({Key? key}) : super(key: key);

//   @override
//   State<InviteEmployee> createState() => _InviteEmployeeState();
// }

// class _InviteEmployeeState extends State<InviteEmployee> {
//   UserController controller = Get.put(UserController());
//   bool selected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: backButton(),
//         title: searchBar(controller),
//       ),
//       body: FutureBuilder(
//           future: controller.getEmployess(),
//           builder: (context, snapshot) {
//             return Obx(() => ListView.builder(
//                   shrinkWrap: true,
//                   padding: defaultPadding,
//                   itemCount: controller.employeList.length,
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     var data = controller.employeList[index];
//                     return EmployeListItem(
//                       index: index,
//                       employeModel: UserModel(
//                         name: data.name,
//                         userId: data.userId,
//                         email: data.email,
//                         status: data.status,
//                         employeImage: data.employeImage,
//                       ),
//                     );
//                   },
//                 ));
//           }),
//     );
//   }
// }

// class EmployeListItem extends StatefulWidget {
//   final UserModel employeModel;
//   final int index;

//   const EmployeListItem({Key? key, required this.employeModel, required this.index}) : super(key: key);

//   @override
//   State<EmployeListItem> createState() => _EmployeListItemState();
// }

// class _EmployeListItemState extends State<EmployeListItem> {
//   UserController controller = Get.put(UserController());
//   bool selected = false;

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < controller.dummyEmploye.length; i++) {
//       if (controller.dummyEmploye[i].email == widget.employeModel.email) {
//         selected = true;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
// margin: const EdgeInsets.only(bottom: 15),
// decoration: BoxDecoration(
//   color: kPrimaryColor,
//   borderRadius: RadiusHandler.radius10,
//   boxShadow: [
//     BoxShadow(
//       offset: const Offset(2, 2),
//       blurRadius: 8,
//       color: kBlackColor.withOpacity(0.04),
//     ),
//   ],
// ),
//       child: ListTile(
//         onTap: () async {
//           setState(() {
//             selected = !selected;
//           });
//           if (selected == true) {
//             controller.dummyEmploye.add(widget.employeModel);
//           } else {
//             controller.dummyEmploye.removeWhere((element) => element.email == widget.employeModel.email);
//           }
//           print(controller.dummyEmploye.value.length);
//           for (int i = 0; i < controller.dummyEmploye.value.length; i++) {
//             print(controller.dummyEmploye[i].email);
//           }
//         },
//         /*=> controller.selectEmployees(
//               profileImage,
//               name,
//               status,
//               isSelected,
//               index,
//             ),*/
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 10,
//         ),
//         leading: ClipRRect(
//           borderRadius: RadiusHandler.radius10,
//           child: Image.asset(
//             "assets/images/dummy_chat/anika.png",
//             fit: BoxFit.cover,
//             height: 50,
//             width: 50,
//           ),
//         ),
      //   title: MyText(
      //     text: widget.employeModel.email,
      //     weight: FontWeight.w500,
      //   ),
      //   subtitle: MyText(
      //     text: widget.employeModel.email,
      //     size: 12,
      //   ),
      //   trailing: selected
      //       ? Image.asset(
      //           kSelectIcon,
      //           height: 16,
      //         )
      //       : const SizedBox(),
      // ),
//     );
//   }
// }

// TextFormField searchBar(UserController controller) {
//   return TextFormField(
//     style: TextFieldStyling.textStyle,
//     textAlignVertical: TextAlignVertical.center,
//     decoration: InputDecoration(
//       prefixIconConstraints: const BoxConstraints(
//         minWidth: 30,
//       ),
//       prefixIcon: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () async {
//               await Get.find<UserController>().getEmployess();
//             },
//             child: Image.asset(
//               kSearchIcon,
//               height: 18,
//               color: kPurpleColor,
//             ),
//           ),
//         ],
//       ),
//       hintText: 'Search employee',
//       hintStyle: TextFieldStyling.hintStyle,
//       enabledBorder: TextFieldStyling.enableBorder,
//       focusedBorder: TextFieldStyling.focusBorder,
//     ),
//   );
// }
