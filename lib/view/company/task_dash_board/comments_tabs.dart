import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:copter/view/widget/send_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Controllers/tasks_controller.dart';
import 'package:get/get.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TaskController taskController = Get.find();
  TextEditingController commentController = TextEditingController();

  Future<String?> getPhoto(String uid) async {
    final snap = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return snap.data()?["photo"];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .doc((taskController.selectedTask?.path).toString())
                    .collection("comments")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 200,
                              child: Center(
                                child: MyText(
                                  text: "No comments yet",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 200,
                              child: Center(
                                child: MyText(
                                  text: "No Comments Yet",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    var data = snapshot.data!;

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return FutureBuilder<String?>(
                            future: getPhoto(data.docs[index]["owner"]),
                            builder: (context, snapshot) {
                              return CommentsCards(
                                profileImage: snapshot.data,
                                comment: data.docs[index]["text"],
                                name: data.docs[index]["name"],
                                time: DateFormat(DateFormat.MONTH_WEEKDAY_DAY)
                                    .format(DateTime.parse(data.docs[index]["time"].toDate().toString())),
                              );
                            },
                          );
                        },
                        childCount: data.docs.length,
                      ),
                    );
                  }
                }),
          ],
        ),
        SendField(
          hintText: 'type here...',
          onTap: () {
            // print(commentController.value.text);
            final UserController user = Get.find();
            if (commentController.value.text.isNotEmpty) {
              FirebaseFirestore.instance
                  .doc((taskController.selectedTask?.path).toString())
                  .collection("comments")
                  .add({
                "text": commentController.value.text,
                "time": FieldValue.serverTimestamp(),
                "name": user.name.value,
                "owner": user.uid.value
              });
              commentController.clear();
            }
          },
          controller: commentController,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CommentsCards extends StatelessWidget {
  CommentsCards({
    Key? key,
    this.profileImage,
    this.name,
    this.comment,
    this.time,
  }) : super(key: key);

  String? profileImage, name, comment, time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: RadiusHandler.radius100,
              child: CachedNetworkImage(
                imageUrl: profileImage ?? "",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(Icons.person_rounded),
                ),
              ),
            ),
            title: MyText(
              text: '$name',
              weight: FontWeight.w500,
            ),
            trailing: MyText(
              text: '$time',
              size: 10,
            ),
          ),
          Row(
            children: [
              Container(
                width: 73,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // haveMedia!
                    //     ? SizedBox(
                    //         height: 65,
                    //         child: ListView.separated(
                    //           padding: const EdgeInsets.only(right: 15),
                    //           separatorBuilder: (context, index) =>
                    //               const SizedBox(
                    //             width: 3,
                    //           ),
                    //           itemCount: mediaImages!.length,
                    //           shrinkWrap: true,
                    //           scrollDirection: Axis.horizontal,
                    //           physics: const BouncingScrollPhysics(),
                    //           itemBuilder: (context, index) {
                    //             return Image.asset(
                    //               mediaImages![index],
                    //               height: 65,
                    //               width: 65,
                    //               fit: BoxFit.cover,
                    //             );
                    //           },
                    //         ),
                    //       )
                    //     : const SizedBox(),
                    MyText(
                      paddingTop: 10,
                      paddingBottom: 15,
                      paddingRight: 15,
                      text: '$comment',
                      size: 12,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     haveReplies!
                    //         ? Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Stack(
                    //                 clipBehavior: Clip.none,
                    //                 children: [
                    //                   replyingPersons(
                    //                     peopleWhoReply![0],
                    //                   ),
                    //                   Positioned(
                    //                     left: 15,
                    //                     child: replyingPersons(
                    //                       peopleWhoReply![1],
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                     left: 30,
                    //                     child: replyingPersons(
                    //                       peopleWhoReply![2],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               MyText(
                    //                 text: '$totalReplies replies',
                    //                 paddingLeft: 35,
                    //                 size: 10,
                    //                 color: kDarkPurpleColor,
                    //               ),
                    //             ],
                    //           )
                    //         : MyText(
                    //             text: 'No replies',
                    //             size: 10,
                    //             color: kDarkPurpleColor,
                    //           ),
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: MyText(
                    //         text: 'Reply',
                    //         paddingRight: 15,
                    //         size: 12,
                    //         weight: FontWeight.w500,
                    //         color: kSecondaryColor,
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget replyingPersons(String? img) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: RadiusHandler.radius100,
      ),
      child: ClipRRect(
        borderRadius: RadiusHandler.radius100,
        child: Image.asset(
          '$img',
          height: 20,
          width: 20,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
