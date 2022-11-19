import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Models/user_model.dart';
import 'package:get/get.dart';

import '../Models/chat_model.dart';

class ChatController extends GetxController {
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<UserModel> inboxList = <UserModel>[].obs;

  getChat({required String employeeUid, required String company, required String currentUserid}) async {
    FirebaseFirestore.instance
        .collection(company)
        .doc("users")
        .collection("users")
        .doc(currentUserid)
        .collection("inbox")
        .doc(employeeUid)
        .collection("chat")
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      chatList.value = ChatModel.jsonToListView(event.docs);
    });
  }

  getChatInbox({required String company, required String currentUserid}) async {
    FirebaseFirestore.instance
        .collection(company)
        .doc("users")
        .collection("users")
        .doc(currentUserid)
        .collection("inbox")
        .snapshots()
        .listen((event) {
      inboxList.value = UserModel.jsonToListView(event.docs);
    });
  }
}
