import 'package:copter/Controllers/calander_controller.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'my_text.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: kDarkPurpleColor,
      onDayPressed: (date, events) {
        final CalanderController calanderController = Get.find();
        calanderController.selectedDate.value = date;
        calanderController.update();
        setState(() => _currentDate2 = date);
        // for (var event in events) {
        //   if (kDebugMode) {
        //     print(event.title);
        //   }
        // }
      },
      showHeaderButton: false,
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: false,
      iconColor: kLightGreyColor,
      weekendTextStyle: const TextStyle(
        color: Color(0xffFF658B),
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      weekFormat: false,
      dayPadding: 6,
      weekDayMargin: const EdgeInsets.symmetric(vertical: 10),
      daysTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: kBlackColor,
        fontSize: 14,
      ),
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      showHeader: false,
      selectedDayButtonColor: kSecondaryColor.withOpacity(0.1),
      pageScrollPhysics: const BouncingScrollPhysics(),
      selectedDayTextStyle: const TextStyle(
        color: kSecondaryColor,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      weekdayTextStyle: const TextStyle(
        color: kBlackColor,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      todayTextStyle: const TextStyle(
        color: kSecondaryColor,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      childAspectRatio: 0.9,
      minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      prevDaysTextStyle: const TextStyle(
        color: kPurpleColor,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      inactiveDaysTextStyle: const TextStyle(
        color: kSecondaryColor,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      nextMonthDayBorderColor: Colors.transparent,
      prevMonthDayBorderColor: Colors.transparent,
      thisMonthDayBorderColor: Colors.transparent,
      selectedDayBorderColor: Colors.transparent,
      nextDaysTextStyle: const TextStyle(
        color: kPurpleColor,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      inactiveWeekendTextStyle: const TextStyle(
        color: kSecondaryColor,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      markedDateCustomTextStyle: const TextStyle(
        color: kSecondaryColor,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      dayButtonColor: kPrimaryColor,
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
        });
      },
      onDayLongPressed: (DateTime date) {
        if (kDebugMode) {
          print('long pressed date $date');
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyText(
          text: DateFormat("dd MMM, yyyy").format(DateTime.now()),
          color: kPurpleColor,
        ),
        MyText(
          text: 'Today',
          weight: FontWeight.w500,
          color: kBlackColor2,
          size: 18,
          paddingBottom: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Task Calender',
              size: 18,
              weight: FontWeight.w500,
              color: kSecondaryColor,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _targetDateTime = DateTime(
                        _targetDateTime.year,
                        _targetDateTime.month - 1,
                      );
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                  child: Image.asset(
                    kPreviousMonth,
                    height: 20,
                  ),
                ),
                MyText(
                  text: _currentMonth,
                  color: kBlackColor2,
                  paddingLeft: 10,
                  paddingRight: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                  child: Image.asset(
                    kNextMonth,
                    height: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 350,
          child: calendarCarouselNoHeader,
        ),
      ],
    );
  }
}
