/*import 'package:copter/controller/chat_controller/chat_head_controller.dart';*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Models/userModel.dart';
import 'package:copter/view/chat/chat_screen.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/chatController.dart';
import '../../Controllers/userController.dart';
import 'add_chat.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatHead extends StatefulWidget {
  const ChatHead({Key? key}) : super(key: key);

  @override
  State<ChatHead> createState() => _ChatHeadState();
}

class _ChatHeadState extends State<ChatHead> {
  UserController userController = Get.put(UserController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              toolbarHeight: 80,
              leadingWidth: 75,
              pinned: true,
              leading: currentUser(),
              title: MyText(
                size: 14,
                text: 'Messages',
                weight: FontWeight.w500,
              ),
              bottom: PreferredSize(
                preferredSize: const Size(0, 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    search(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              sliver: FutureBuilder(
                  future: chatController.getChatInbox(
                    company: userController.companyType.value,
                    currentUserid: userController.uid.value,
                  ),
                  builder: (context, snapshot) {
                    return Obx(() => SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              //var dummyData = controller.getDummyChats[index];
                              var data = chatController.inboxList[index];
                              return ChatHeadTiles(
                                employeListItem: UserModel(
                                  name: data.name,
                                  email: data.email,
                                  status: data.status,
                                  userId: data.userId,
                                  employeImage: data.employeImage,
                                ),
                              );
                            },
                            childCount: chatController.inboxList.value.length,
                          ),
                        ));
                  }),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 70,
              ),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 80,
          child: FloatingActionButton(
            child: Icon(Icons.chat),
            onPressed: () {
              Get.to(AddChat());
            },
            backgroundColor: kPurpleColor,
          ),
        )
      ],
    );
  }
}

Widget search() {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
    child: TextFormField(
      decoration: InputDecoration(
        hintText: 'Search employee...',
        hintStyle: const TextStyle(
          color: kLightPurpleColor2,
        ),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kSearchIcon,
              height: 18,
              color: kPurpleColor,
            ),
          ],
        ),
        enabledBorder: TextFieldStyling.noBorder,
        focusedBorder: TextFieldStyling.noBorder,
      ),
    ),
  );
}

Widget currentUser() {
  return Padding(
    padding: const EdgeInsets.only(left: 25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: RadiusHandler.radius100,
              child: Image.asset(
                'assets/images/dummy_chat/user.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Align(
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    borderRadius: RadiusHandler.radius100,
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 2.0,
                    ),
                    color: kOnlineGreenColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ignore: must_be_immutable
class ChatHeadTiles extends StatelessWidget {
  ChatHeadTiles({
    Key? key,
    required this.employeListItem,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  UserModel employeListItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(2, 2),
            color: kBlackColor.withOpacity(0.05),
          ),
        ],
        borderRadius: RadiusHandler.radius10,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: kBlackColor.withOpacity(0.02),
          highlightColor: kBlackColor.withOpacity(0.02),
        ),
        child: ListTile(
          shape: RadiusHandler.roundedRadius10,
          tileColor: kPrimaryColor,
          onTap: () => Get.to(
            () => ChatScreen(employeModel: employeListItem),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(180),
            child: CachedNetworkImage(
              imageUrl: employeListItem.employeImage,
              fit: BoxFit.cover,
              height: 50,
              width: 50,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(Icons.person_rounded),
              ),
            ),
          ),
          title: MyText(
            text: employeListItem.name,
            weight: FontWeight.w500,
            color: kBlackColor2,
            paddingBottom: 5,
            maxLines: 1,
            overFlow: TextOverflow.ellipsis,
          ),
          subtitle: MyText(
            text: employeListItem.email,
            size: 12,
            maxLines: 1,
            overFlow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

Widget personProfileImage(String profileImage, bool online) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 0),
              color: kBlackColor.withOpacity(0.16),
            ),
          ],
          borderRadius: RadiusHandler.radius100,
          color: kPrimaryColor,
        ),
        child: ClipRRect(
          borderRadius: RadiusHandler.radius100,
          child: Image.asset(
            profileImage,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        bottom: 3,
        right: 2,
        child: Align(
          child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              borderRadius: RadiusHandler.radius100,
              border: Border.all(
                color: kPrimaryColor,
                width: 2.0,
              ),
              color: online ? kOnlineGreenColor : kLastSeenColor,
            ),
          ),
        ),
      ),
    ],
  );
}
