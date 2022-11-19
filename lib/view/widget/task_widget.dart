import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/tasksController.dart';
import 'package:copter/view/company/task_dash_board/task_dash_board.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class TasKWidget extends StatelessWidget {
  TasKWidget({
    Key? key,
    this.taskList = 'allTasks',
    this.projectTitle,
    this.urgentProject = false,
    this.timeLeft,
    this.personsWorking,
    required this.indicatorProgress,
    this.taskIndex = 0,
    this.taskRef,
  }) : super(key: key);
  String taskList;
  final int taskIndex;
  String? projectTitle, timeLeft;
  int? personsWorking;
  bool urgentProject;
  double indicatorProgress = 0.0;
  Color? progressBarColor;
  DocumentReference? taskRef;

  String? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 110,
      child: Card(
        shape: RadiusHandler.roundedRadius10,
        margin: EdgeInsets.zero,
        color: kPrimaryColor,
        elevation: 10,
        shadowColor: kBlackColor.withOpacity(0.2),
        child: InkWell(
          onTap: () {
            Get.find<TaskController>().selectedTask = taskRef;
            Get.find<TaskController>().selectedTaskList = taskList;

            Get.to(
              () => TaskDashBoard(
                uid: taskRef!.id,
                projectTitle: projectTitle,
                urgentProject: urgentProject,
                indicatorProgress: indicatorProgress,
              ),
            );
          },
          splashColor: kBlackColor.withOpacity(0.02),
          highlightColor: kBlackColor.withOpacity(0.02),
          borderRadius: RadiusHandler.radius10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: '$projectTitle',
                      weight: FontWeight.w500,
                      color: kBlackColor2,
                    ),
                    Container(
                      height: 22,
                      width: 65,
                      decoration: BoxDecoration(
                        color: urgentProject ? kRedColor.withOpacity(0.1) : kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: MyText(
                          text: urgentProject ? 'Urgent' : 'Ongoing',
                          size: 10,
                          color: urgentProject ? kRedColor : kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
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
                      text: '${getProgress(indicatorProgress)}% complete',
                      size: 12,
                      color: getProgressBarColor(indicatorProgress),
                    ),
                  ],
                ),
                LinearPercentIndicator(
                  lineHeight: 7,
                  percent: indicatorProgress,
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
                        color: getProgressBarColor(indicatorProgress),
                        border: Border.all(
                          width: 2.0,
                          color: kPrimaryColor,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  backgroundColor: const Color(0xffF4F4FF),
                  progressColor: getProgressBarColor(indicatorProgress),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Wrap(
                        spacing: 10.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            kClockLight,
                            height: 15,
                          ),
                          Text(
                            indicatorProgress == 1.0 ? '' : '$timeLeft days left',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: urgentProject ? kRedColor : kPurpleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.end,
                        spacing: 10,
                        children: [
                          MyText(
                            text: '$personsWorking persons',
                            size: 10,
                            color: kPurpleColor,
                          ),
                          Image.asset(
                            kPersonsIcon,
                            height: 11,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
