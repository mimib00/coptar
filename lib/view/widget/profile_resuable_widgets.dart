import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'my_text.dart';

// ignore: must_be_immutable
class ProfileTiles extends StatefulWidget {
  ProfileTiles({
    Key? key,
    this.icon,
    this.title,
    this.iconSize,
    this.bgColor,
    this.onTap,
    this.haveNotificationButton = false,
  }) : super(key: key);
  String? icon, title;
  double? iconSize;
  Color? bgColor;
  bool? haveNotificationButton;
  VoidCallback? onTap;

  @override
  State<ProfileTiles> createState() => _ProfileTilesState();
}

class _ProfileTilesState extends State<ProfileTiles> {
  bool? enableNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: widget.bgColor!.withOpacity(0.05),
            splashColor: widget.bgColor!.withOpacity(0.05),
          ),
          child: ListTile(
            onTap: widget.onTap,
            shape: RadiusHandler.roundedRadius10,
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: widget.bgColor!.withOpacity(0.1),
                borderRadius: RadiusHandler.radius10,
              ),
              child: Center(
                child: Image.asset(
                  widget.icon!,
                  height: widget.iconSize!,
                ),
              ),
            ),
            title: MyText(
              text: widget.title!,
            ),
            trailing: widget.haveNotificationButton == true
                ? SizedBox(
                    width: 40,
                    height: 20,
                    child: FlutterSwitch(
                      padding: 1.3,
                      toggleSize: 16.2,
                      inactiveColor: kSecondaryColor.withOpacity(0.1),
                      toggleColor: kSecondaryColor,
                      activeColor: kSecondaryColor.withOpacity(0.1),
                      toggleBorder: Border.all(
                        color: kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius: 50.0,
                      value: enableNotifications!,
                      onToggle: (val) {
                        setState(() {
                          enableNotifications = !enableNotifications!;
                        });
                      },
                    ),
                  )
                : Image.asset(
                    kArrowForwardIos,
                    height: 15,
                  ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProgressBars extends StatefulWidget {
  ProgressBars({
    Key? key,
    this.title,
    this.indicatorProgress,
  }) : super(key: key);
  double? indicatorProgress;
  String? title;

  @override
  State<ProgressBars> createState() => _ProgressBarsState();
}

class _ProgressBarsState extends State<ProgressBars> {
  Color? progressBarColor;
  String? progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: '${widget.title}',
                size: 12,
                color: kBlackColor,
              ),
              MyText(
                text: '${getProgress(widget.indicatorProgress!)}%',
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
            percent: widget.indicatorProgress!,
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
