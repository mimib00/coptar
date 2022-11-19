/*import 'package:copter/controller/company_controller/task_controller/task_controller.dart';*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:copter/Models/user_model.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/back_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/user_controller.dart';
import 'chat_screen.dart';

class AddChat extends StatefulWidget {
  const AddChat({Key? key}) : super(key: key);

  @override
  State<AddChat> createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(),
        title: searchBar(controller),
      ),
      body: FutureBuilder(
        future: controller.getEmployess(),
        builder: (context, snapshot) {
          return Obx(
            () => ListView.builder(
              shrinkWrap: true,
              padding: defaultPadding,
              itemCount: controller.employeList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var data = controller.employeList[index];
                return EmployeListItem(
                  index: index,
                  employeModel: UserModel(
                    name: data.name,
                    userId: data.userId,
                    email: data.email,
                    status: data.status,
                    employeImage: data.employeImage,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EmployeListItem extends StatefulWidget {
  final UserModel employeModel;
  final int index;

  const EmployeListItem({Key? key, required this.employeModel, required this.index}) : super(key: key);

  @override
  State<EmployeListItem> createState() => _EmployeListItemState();
}

class _EmployeListItemState extends State<EmployeListItem> {
  UserController controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: RadiusHandler.radius10,
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 8,
            color: kBlackColor.withOpacity(0.04),
          ),
        ],
      ),
      child: ListTile(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  employeModel: widget.employeModel,
                ),
              ));
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: CachedNetworkImage(
            imageUrl: widget.employeModel.employeImage,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
            errorWidget: (context, url, error) => const CircleAvatar(
              child: Icon(Icons.person_rounded),
            ),
          ),
        ),
        title: MyText(
          text: widget.employeModel.name,
          weight: FontWeight.w500,
        ),
        subtitle: MyText(
          text: widget.employeModel.email,
          size: 12,
        ),
      ),
    );
  }
}

TextFormField searchBar(UserController controller) {
  return TextFormField(
    style: TextFieldStyling.textStyle,
    textAlignVertical: TextAlignVertical.center,
    decoration: InputDecoration(
      prefixIconConstraints: const BoxConstraints(
        minWidth: 30,
      ),
      prefixIcon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              await Get.find<UserController>().getEmployess();
            },
            child: Image.asset(
              kSearchIcon,
              height: 18,
              color: kPurpleColor,
            ),
          ),
        ],
      ),
      hintText: 'Search employee',
      hintStyle: TextFieldStyling.hintStyle,
      enabledBorder: TextFieldStyling.enableBorder,
      focusedBorder: TextFieldStyling.focusBorder,
    ),
  );
}
