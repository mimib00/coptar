import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String name, email, message;
  Timestamp time;
  bool isme;

  ChatModel({
    required this.name,
    required this.time,
    required this.message,
    required this.email,
    required this.isme,
  });

  factory ChatModel.fromJson(DocumentSnapshot snapshot) {
    return ChatModel(
      name: (snapshot.data() as dynamic)["name"] ?? " ",
      email: (snapshot.data() as dynamic)["email"] ?? " ",
      message: (snapshot.data() as dynamic)["msg"] ?? " ",
      time: (snapshot.data() as dynamic)["time"],
      isme: (snapshot.data() as dynamic)["IsMe"] ?? false,
    );
  }

  Map<String, dynamic> toJson(ChatModel model) {
    return {
      "name": model.name,
      "number": model.email,
      "IsMe": model.isme,
    };
  }

  static List<ChatModel> JsonToListView(List<DocumentSnapshot> jsonList) {
    return jsonList.map((e) => ChatModel.fromJson(e)).toList();
  }
}
