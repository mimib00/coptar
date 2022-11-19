/*
import 'package:copter/controller/login_controller/login_controller.dart';
*/

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/tasks_controller.dart';
import 'package:copter/Models/user_model.dart';
import 'package:copter/view/company/task_dash_board/comments_tabs.dart';
import 'package:copter/view/company/task_dash_board/file_tab.dart';
import 'package:copter/view/company/task_dash_board/tasks_tab.dart';
import 'package:copter/view/company/tasks/add_task.dart';
import 'package:copter/view/company/tasks/invite_employees.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/back_button.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class TaskDashBoard extends StatefulWidget {
  TaskDashBoard({
    Key? key,
    required this.uid,
    this.projectTitle,
    this.urgentProject = false,
    this.projectProgress,
    this.indicatorProgress,
    this.haveRequestToJoin = false,
  }) : super(key: key);
  String uid;
  String? projectTitle;

  int? projectProgress;
  bool? urgentProject;
  double? indicatorProgress = 0.0;

  bool? haveRequestToJoin;

  @override
  State<TaskDashBoard> createState() => _TaskDashBoardState();
}

class _TaskDashBoardState extends State<TaskDashBoard> with SingleTickerProviderStateMixin {
  final List<String>? tabs = [
    'Task',
    'File',
    'Comment',
  ];

  int? currentIndex = 0;
  TabController? _controller;

  @override
  void initState() {
    _controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: currentIndex!,
    );
    _controller!.addListener(() {
      setState(() {
        currentIndex = _controller!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<List<String>> getTaskEmployees() async {
    try {
      final current = FirebaseAuth.instance.currentUser!;
      final user = await FirebaseFirestore.instance.collection("users").doc(current.uid).get();
      if (!user.exists) return [];
      final type = user.data()!["companyType"];
      final snap = await FirebaseFirestore.instance
          .collection(type)
          .doc("users")
          .collection("users")
          .where("userId", isNotEqualTo: current.uid)
          .get();
      if (snap.docs.isEmpty) return [];
      List<String> users = [];
      for (var doc in snap.docs) {
        final employee = await FirebaseFirestore.instance
            .collection("users")
            .doc(doc.id)
            .withConverter(
              fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot),
              toFirestore: (value, options) => {},
            )
            .get();
        if (!employee.exists) continue;

        users.add(employee.data()!.employeImage);
      }
      log(users.toString());
      return users;
    } on FirebaseException catch (e) {
      log(e.code);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    TaskController taskController = Get.find();

    // Center(child: Text((taskController.selectedTask?.path).toString())),
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.doc((taskController.selectedTask?.path).toString()).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var data = snapshot.data!;

                return Stack(
                  children: [
                    NestedScrollView(
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            backgroundColor: kPrimaryColor,
                            centerTitle: true,
                            pinned: true,
                            leading: backButton(),
                            title: MyText(
                              text: 'Task Dashboard',
                              weight: FontWeight.w500,
                              size: 14,
                              color: kBlackColor2,
                            ),
                            actions: [
                              /* LoginController.currentUser == 'company'
                                  ? */
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.back();

                                            Get.to(
                                              () => const AddTask(isEdit: true),
                                            );
                                          },
                                          child: MyText(
                                            text: 'Edit Task',
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () async {
                                          Get.back();
                                          await FirebaseFirestore.instance
                                              .doc((taskController.selectedTask?.path).toString())
                                              .delete();
                                          taskController.selectedTask = null;
                                        },
                                        child: MyText(
                                          text: 'Delete Task',
                                          size: 12,
                                        ),
                                      ),
                                      // PopupMenuItem(
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       Get.back();
                                      //       Get.to(
                                      //         () => const GiveRating(),
                                      //       );
                                      //     },
                                      //     child: MyText(
                                      //       text: 'Rated',
                                      //       size: 12,
                                      //     ),
                                      //   ),
                                      // ),
                                    ];
                                  },
                                  shape: RadiusHandler.roundedRadius10,
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: kSecondaryColor,
                                    size: 30,
                                  ),
                                ),
                              )
                              // : const SizedBox(),
                            ],
                            expandedHeight: 340,
                            flexibleSpace: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 110),
                                  child: FutureBuilder<List<String>>(
                                    future: getTaskEmployees(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                                        return TaskDetails(
                                          uid: widget.uid,
                                          projectTitle: widget.projectTitle,
                                          urgentProject: widget.urgentProject,
                                          indicatorProgress: widget.indicatorProgress,
                                          persons: const [
                                            'assets/images/dummy_chat/tatiana.png',
                                            'assets/images/dummy_chat/haylie.png',
                                            'assets/images/dummy_chat/anika.png',
                                          ],
                                          description: data["description"],
                                          timeLeft: "${data['end'].toDate().difference(
                                                DateTime.now(),
                                              ).inDays} Days",
                                        );
                                      }
                                      return TaskDetails(
                                        uid: widget.uid,
                                        projectTitle: widget.projectTitle,
                                        urgentProject: widget.urgentProject,
                                        indicatorProgress: widget.indicatorProgress,
                                        persons: snapshot.data!,
                                        // persons: const [
                                        //   'assets/images/dummy_chat/tatiana.png',
                                        //   'assets/images/dummy_chat/haylie.png',
                                        //   'assets/images/dummy_chat/anika.png',
                                        // ],
                                        description: data["description"],
                                        timeLeft: "${data['end'].toDate().difference(
                                              DateTime.now(),
                                            ).inDays} Days",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            bottom: PreferredSize(
                              preferredSize: const Size(0, 55),
                              child: Column(
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: RadiusHandler.radius10,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kBlackColor.withOpacity(0.04),
                                            offset: const Offset(2, 4),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: TabBar(
                                        padding: EdgeInsets.zero,
                                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                                        controller: _controller,
                                        indicatorColor: Colors.transparent,
                                        tabs: List.generate(
                                          tabs!.length,
                                          (index) => Container(
                                            height: 40,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              borderRadius: RadiusHandler.radius10,
                                              color: currentIndex == index ? kSecondaryColor : kPrimaryColor,
                                            ),
                                            child: Center(
                                              child: MyText(
                                                color: currentIndex == index ? kPrimaryColor : kSecondaryColor,
                                                text: tabs![index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: _controller,
                        children: [
                          const Tasks(),
                          File(data: data["files"]),
                          const Comments(),
                        ],
                      ),
                    ),
                    widget.haveRequestToJoin == true ? acceptRequestToJoin() : const SizedBox(),
                  ],
                );
              }
            }));
  }

  Widget acceptRequestToJoin() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -4),
              color: kBlackColor.withOpacity(0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: MyButton(
                onPressed: () {},
                height: 42,
                text: 'Accept',
                textSize: 14,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: RadiusHandler.radius10,
                  border: Border.all(
                    color: kBorderColor,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: MyText(
                    text: 'Cancel',
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TaskDetails extends StatefulWidget {
  TaskDetails({
    Key? key,
    required this.uid,
    this.projectTitle,
    this.description,
    this.urgentProject = false,
    this.timeLeft,
    this.persons,
    this.indicatorProgress,
  }) : super(key: key);
  String uid;
  String? projectTitle, description, timeLeft;
  int? projectProgress;
  bool? urgentProject;
  double? indicatorProgress = 0.0;
  List<String>? persons;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  Color? progressBarColor;

  String? progress;

  TaskController taskController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.doc((taskController.selectedTask?.path).toString()).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return MyText(text: "No data received");
          } else {
            var data = snapshot.data!;

            // print(data.data().toString());
            var task = data['tasks'].toList();

            int totalCompleted = 0;
            for (Map<String, dynamic> value in task) {
              if (value['isCompleted'] == true) {
                totalCompleted++;
              }
            }

            widget.indicatorProgress = totalCompleted / task.length;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: '${data['title']}',
                      weight: FontWeight.w500,
                      size: 18,
                      color: kSecondaryColor,
                    ),
                    Container(
                      height: 22,
                      width: 65,
                      decoration: BoxDecoration(
                        color: data['type'] == "Urgent" ? kRedColor.withOpacity(0.1) : kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: MyText(
                          text: data['type'] == "Urgent" ? 'Urgent' : 'Ongoing',
                          size: 10,
                          color: data['type'] == "Urgent" ? kRedColor : kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ExpandableText(
                  data['description'],
                  expandText: 'see more',
                  collapseText: 'see less',
                  maxLines: 2,
                  linkEllipsis: true,
                  textAlign: TextAlign.start,
                  linkColor: kSecondaryColor,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kDarkPurpleColor,
                  ),
                  animation: true,
                  collapseOnTextTap: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: widget.persons!
                                .map(
                                  (e) => Positioned(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(180),
                                    child: CachedNetworkImage(
                                      imageUrl: e,
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                      errorWidget: (context, url, error) => const CircleAvatar(
                                        child: Icon(Icons.person_rounded),
                                      ),
                                    ),
                                  )),
                                )
                                .toList(),
                          ),
                          const SizedBox(width: 10),
                          /*LoginController.currentUser == 'company'
                    ? */
                          GestureDetector(
                            onTap: () => Get.to(const InviteEmployee()),
                            child: MyText(
                              text: 'Add more +',
                              size: 12,
                              color: kPurpleColor,
                            ),
                          )
                          //: const SizedBox(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.indicatorProgress != 1.0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  kClock,
                                  height: 15,
                                ),
                                MyText(
                                  text: 'EST. Time',
                                  size: 12,
                                  paddingLeft: 10,
                                )
                              ],
                            ),
                          if (widget.indicatorProgress != 1.0)
                            MyText(
                              paddingTop: 5,
                              text: '${data['end'].toDate().difference(DateTime.now()).inDays} days',
                              weight: FontWeight.w500,
                              color: kBlackColor2,
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Progress',
                      size: 12,
                      color: kBlackColor,
                    ),
                    MyText(
                      text: '${getProgress(widget.indicatorProgress!)}% complete',
                      size: 12,
                      color: getProgressBarColor(widget.indicatorProgress!),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LinearPercentIndicator(
                  lineHeight: 7,
                  percent: progress == null ? 0.0 : double.parse(progress!) / 100,
                  alignment: MainAxisAlignment.center,
                  padding: EdgeInsets.zero,
                  barRadius: const Radius.circular(50),
                  widgetIndicator: Card(
                    shape: RadiusHandler.roundedRadius100,
                    margin: const EdgeInsets.only(bottom: 0),
                    color: kPrimaryColor,
                    elevation: 4,
                    shadowColor: kBlackColor.withOpacity(0.3),
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: getProgressBarColor(widget.indicatorProgress!),
                        border: Border.all(
                          width: 2.0,
                          color: kPrimaryColor,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  backgroundColor: const Color(0xffF4F4FF),
                  progressColor: getProgressBarColor(widget.indicatorProgress!),
                ),
              ],
            );
          }
        });

    // GetX(
    //   init: Get.put<TaskController>(TaskController()),
    //   builder: (TaskController taskController) {
    //     var taskList = taskController.getList();
    //
    //     var task = taskList.value[taskController.selectedTask];
    //     int total_completed = 0;
    //     for (Map<String, dynamic> value in task.tasks) {
    //       if (value['isCompleted'] == true) {
    //         total_completed++;
    //       }
    //     }
    //     widget.indicatorProgress = total_completed / task.tasks.length;
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             MyText(
    //               text: '${task.title}',
    //               weight: FontWeight.w500,
    //               size: 18,
    //               color: kSecondaryColor,
    //             ),
    //             Container(
    //               height: 22,
    //               width: 65,
    //               decoration: BoxDecoration(
    //                 color: task.type == "Urgent"
    //                     ? kRedColor.withOpacity(0.1)
    //                     : kSecondaryColor.withOpacity(0.1),
    //                 borderRadius: BorderRadius.circular(50),
    //               ),
    //               child: Center(
    //                 child: MyText(
    //                   text: task.type == "Urgent" ? 'Urgent' : 'Ongoing',
    //                   size: 10,
    //                   color:
    //                       task.type == "Urgent" ? kRedColor : kSecondaryColor,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         ExpandableText(
    //           task.description,
    //           expandText: 'see more',
    //           collapseText: 'see less',
    //           maxLines: 2,
    //           linkEllipsis: true,
    //           textAlign: TextAlign.start,
    //           linkColor: kSecondaryColor,
    //           style: const TextStyle(
    //             fontSize: 12,
    //             color: kDarkPurpleColor,
    //           ),
    //           animation: true,
    //           collapseOnTextTap: true,
    //         ),
    //         const SizedBox(
    //           height: 25,
    //         ),
    //         Row(
    //           children: [
    //             Expanded(
    //               flex: 7,
    //               child: Row(
    //                 children: [
    //                   Stack(
    //                     clipBehavior: Clip.none,
    //                     children: [
    //                       workingPersons(
    //                         widget.persons![0],
    //                       ),
    //                       Positioned(
    //                         left: 25,
    //                         child: workingPersons(
    //                           widget.persons![1],
    //                         ),
    //                       ),
    //                       Positioned(
    //                         left: 50,
    //                         child: workingPersons(
    //                           widget.persons![2],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   Container(
    //                     width: 55,
    //                   ),
    //                   /*LoginController.currentUser == 'company'
    //               ? */
    //                   GestureDetector(
    //                     onTap: () => Get.to(const InviteEmployee()),
    //                     child: MyText(
    //                       text: 'Add more +',
    //                       size: 12,
    //                       color: kPurpleColor,
    //                     ),
    //                   )
    //                   //: const SizedBox(),
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //               flex: 3,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 children: [
    //                   if (widget.indicatorProgress != 1.0)
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         Image.asset(
    //                           kClock,
    //                           height: 15,
    //                         ),
    //                         MyText(
    //                           text: 'EST. Time',
    //                           size: 12,
    //                           paddingLeft: 10,
    //                         )
    //                       ],
    //                     ),
    //                   if (widget.indicatorProgress != 1.0)
    //                     MyText(
    //                       paddingTop: 5,
    //                       text: DateTime.parse(task.end)
    //                               .difference(DateTime.now())
    //                               .inDays
    //                               .toString() +
    //                           ' days',
    //                       weight: FontWeight.w500,
    //                       color: kBlackColor2,
    //                     )
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 15,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             MyText(
    //               text: 'Progress',
    //               size: 12,
    //               color: kBlackColor,
    //             ),
    //             MyText(
    //               text: '${getProgress(widget.indicatorProgress!)}% complete',
    //               size: 12,
    //               color: getProgressBarColor(widget.indicatorProgress!),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         LinearPercentIndicator(
    //           lineHeight: 7,
    //           percent: progress == null ? 0.0 : double.parse(progress!) / 100,
    //           alignment: MainAxisAlignment.center,
    //           padding: EdgeInsets.zero,
    //           barRadius: const Radius.circular(50),
    //           widgetIndicator: Card(
    //             shape: RadiusHandler.roundedRadius100,
    //             margin: const EdgeInsets.only(bottom: 0),
    //             color: kPrimaryColor,
    //             elevation: 4,
    //             shadowColor: kBlackColor.withOpacity(0.3),
    //             child: Container(
    //               width: 13,
    //               height: 13,
    //               decoration: BoxDecoration(
    //                 color: getProgressBarColor(widget.indicatorProgress!),
    //                 border: Border.all(
    //                   width: 2.0,
    //                   color: kPrimaryColor,
    //                 ),
    //                 borderRadius: BorderRadius.circular(100),
    //               ),
    //             ),
    //           ),
    //           backgroundColor: const Color(0xffF4F4FF),
    //           progressColor: getProgressBarColor(widget.indicatorProgress!),
    //         ),
    //       ],
    //     );
    //   });
  }

  Widget workingPersons(String? img) {
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
          height: 42,
          width: 42,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String? getProgress(double indicatorProgress) {
    int? currentProgress;
    indicatorProgress = indicatorProgress * 100;
    currentProgress = indicatorProgress.toInt();
    progress = currentProgress.toString();
    return progress;
  }

  Color? getProgressBarColor(double indicatorProgress) {
    if (indicatorProgress < 0.5) {
      progressBarColor = kRedColor;
    } else if (indicatorProgress == 0.5 && indicatorProgress < 1.0) {
      progressBarColor = kYellowColor;
    } else if (indicatorProgress == 1.0) {
      progressBarColor = kGreenColor;
    }
    return progressBarColor;
  }
}
