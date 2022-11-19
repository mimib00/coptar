import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Models/user_model.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/send_fields.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controllers/chat_controller.dart';
import '../../Controllers/user_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    this.employeModel,
  }) : super(key: key);

  final UserModel? employeModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ignore: prefer_typing_uninitialized_variables
  TextEditingController msg = TextEditingController();
  UserController userController = Get.put(UserController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 110,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  kArrowBack,
                  width: 24,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: CachedNetworkImage(
                imageUrl: widget.employeModel!.employeImage,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(Icons.person_rounded),
                ),
              ),
            ),
          ],
        ),
        title: MyText(
          text: widget.employeModel!.name,
          weight: FontWeight.w600,
          color: kBlackColor2,
        ),
        actions: [
          Center(
            child: Image.asset(
              kAudioCallIcon,
              height: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Image.asset(
                kVideoCallIcon,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 40),
            child: FutureBuilder(
                future: chatController.getChat(
                  employeeUid: widget.employeModel!.userId,
                  company: userController.companyType.value,
                  currentUserid: userController.uid.value,
                ),
                builder: (context, snapshot) {
                  return Obx(() => ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: chatController.chatList.length,
                        itemBuilder: (context, index) {
                          /*var data = controller.getDummyMsg[index];*/
                          var data = chatController.chatList[index];
                          return ChatBubble(
                            index: index,
                            time: data.time,
                          );
                        },
                      ));
                }),
          ),
          SendField(
            controller: msg,
            hintText: 'type here...',
            onTap: () async {
              final dio = Dio();
              String message = msg.text.toString();
              int time = DateTime.now().microsecondsSinceEpoch;
              setState(() {
                msg.clear();
              });
              await FirebaseFirestore.instance
                  .collection(userController.companyType.value)
                  .doc("users")
                  .collection("users")
                  .doc(userController.uid.value)
                  .collection("inbox")
                  .doc(widget.employeModel!.userId)
                  .set({
                "email": widget.employeModel!.email,
                "userId": widget.employeModel!.userId,
                "name": widget.employeModel!.name,
              });

              await FirebaseFirestore.instance
                  .collection(userController.companyType.value)
                  .doc("users")
                  .collection("users")
                  .doc(userController.uid.value)
                  .collection("inbox")
                  .doc(widget.employeModel!.userId)
                  .collection("chat")
                  .doc("$time")
                  .set({"msg": message, "time": FieldValue.serverTimestamp(), "IsMe": true});

              /////////////////////////////
              await FirebaseFirestore.instance
                  .collection(userController.companyType.value)
                  .doc("users")
                  .collection("users")
                  .doc(widget.employeModel!.userId)
                  .collection("inbox")
                  .doc(userController.uid.value)
                  .set({
                "userId": userController.uid.value,
                "email": userController.email.value,
                "name": userController.name.value
              });

              await FirebaseFirestore.instance
                  .collection(userController.companyType.value)
                  .doc("users")
                  .collection("users")
                  .doc(widget.employeModel!.userId)
                  .collection("inbox")
                  .doc(userController.uid.value)
                  .collection("chat")
                  .doc("$time")
                  .set({"msg": message, "time": FieldValue.serverTimestamp(), "IsMe": false});
              try {
                const url = "https://us-central1-copter-439c8.cloudfunctions.net/sendNotification";
                dio.post(
                  url,
                  data: {
                    "uid": widget.employeModel!.userId,
                    "title": widget.employeModel!.name,
                    "body": "message: $message",
                    "type": "chat",
                    "task": "",
                  },
                );
              } on DioError catch (e) {
                log(e.message);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatBubble extends StatelessWidget {
  ChatBubble({
    Key? key,
    required this.time,
    required this.index,
  }) : super(key: key);
  final Timestamp time;
  final int index;

  ChatController chatController = Get.put(ChatController());

  // String? msg, time, senderType;
  // bool? isSeen;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: !chatController.chatList[index].isme ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.08),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 30),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.0,
          children: [
            MyText(
              text: chatController.chatList[index].message,
            ),
            MyText(
              text: DateFormat("hh:mm a").format(time.toDate()),
              size: 10,
            ),
          ],
        ),
      ),
    );
  }
}
