import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/view/chat/chat_head.dart';
import 'package:copter/view/company/c_home.dart';
import 'package:copter/view/company/tasks/add_task.dart';
import 'package:copter/view/company/tasks/tasks.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/employee/e_home.dart';
import 'package:copter/view/notifications/c_notifications.dart';
import 'package:copter/view/notifications/e_notifications.dart';
import 'package:copter/view/profile/e_profile.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> employeeScreens = [
    EHome(),
    const ENotifications(),
    // Tasks(),
    const ChatHead(),
    const EProfile(),
  ];
  final List<Widget> companyScreen = const [
    CHome(),
    CNotifications(),
    // SizedBox(),
    ChatHead(),
    Tasks(),
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      floatingActionButton: InkWell(
        onTap: () {
          setState(() {
            if (userController.userType.value == 'company') {
              Get.to(() => const AddTask());
            } else {
              Get.to(() => const Tasks());
            }
          });
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 16,
                offset: const Offset(0, 0),
                color: kSecondaryColor.withOpacity(0.2),
              ),
            ],
          ),
          child: Center(
            child: userController.userType.value == 'company'
                ? const Icon(
                    Icons.add,
                    size: 30,
                    color: kPrimaryColor,
                  )
                : Image.asset(
                    kTaskIcon,
                    height: 20,
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        index: currentIndex,
        children: userController.userType.value == 'company' ? companyScreen : employeeScreens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          const BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          const BottomNavigationBarItem(label: 'Notification', icon: Icon(Icons.notification_add_outlined)),
          const BottomNavigationBarItem(label: 'Message', icon: Icon(Icons.message_rounded)),
          BottomNavigationBarItem(
              label: userController.userType.value == 'company' ? 'Task' : 'Profile',
              icon: userController.userType.value == 'company' ? const Icon(Icons.task) : const Icon((Icons.person))),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class RootItem extends StatelessWidget {
  String icon, label;
  bool isSelected;
  VoidCallback onTap;

  RootItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                icon,
                height: 18,
                color: isSelected ? kSecondaryColor : kDarkPurpleColor,
              ),
              MyText(
                text: label,
                size: 10,
                color: isSelected ? kSecondaryColor : kDarkPurpleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
