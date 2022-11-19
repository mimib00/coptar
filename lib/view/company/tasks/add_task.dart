/*
import 'package:copter/controller/company_controller/task_controller/task_controller.dart';
*/
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/tasksController.dart';
import 'package:copter/Controllers/userController.dart';
import 'package:copter/Models/userModel.dart';
import 'package:copter/routes/bindings.dart';
import 'package:copter/view/company/tasks/invite_employees.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/custom_app_bar.dart';
import 'package:copter/view/widget/my_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../Models/taskModel.dart';

class AddTask extends StatefulWidget {
  late bool isEdit;

  AddTask({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TaskController taskController = Get.find();
  List<TextEditingController> tasksCollection = [TextEditingController()];

  UserController userController = Get.find();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController calendarStartController = TextEditingController();

  TextEditingController calendarEndController = TextEditingController();

  String selectedType = 'Urgent';

  UserController controller = Get.put(UserController());
  List<File> files = [];
  List<String> imageURL = [];

  @override
  void initState() {
    controller.dummyEmploye.clear();
    calendarStartController.text = DateTime.now().toString().split(" ")[0];
    calendarEndController.text =
        DateTime.parse(calendarStartController.text).add(const Duration(days: 1)).toString().split(" ")[0];
    if (widget.isEdit) {
      updateControllersForEdit();
    }
    super.initState();
  }

  TaskController tc = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create Task',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AddTaskFiles(
                  labelText: 'Task name',
                  hintText: 'Type here...',
                  controller: nameController,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      MyText(
                        text: 'Task description ',
                        weight: FontWeight.w500,
                      ),
                      MyText(
                        text: '(1000)',
                        size: 12,
                      ),
                    ],
                  ),
                ),
                AddTaskFiles(
                  haveLabel: false,
                  hintText: 'Type here...',
                  maxLines: 4,
                  controller: descriptionController,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Task to do',
                        weight: FontWeight.w500,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tasksCollection.add(TextEditingController());
                          });
                          print(tasksCollection);
                        },
                        child: MyText(
                          text: 'Add +',
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // AddTaskFiles(
                //   haveLabel: false,
                //   hintText: 'Type here...',
                // ),
                Column(
                  children: tasksCollection.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tasksCollection.length > 1)
                          GestureDetector(
                            onTap: () {
                              print("delete pressed");
                              setState(() {
                                tasksCollection.remove(e);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 3),
                              child: Image.asset(
                                kDeleteIcon,
                                height: 20,
                              ),
                            ),
                          ),
                        AddTaskFiles(
                          haveLabel: false,
                          hintText: 'Type here...',
                          controller: e,
                        ),
                      ],
                    );
                  }).toList(),
                ),
                // AddTaskFiles(
                //   haveLabel: false,
                //   hintText: 'Create a story board',
                // ),
                Row(
                  children: [
                    Expanded(
                      child: AddTaskFiles(
                        haveCalendar: true,
                        labelText: 'Start',
                        hintText: '',
                        controller: calendarStartController,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AddTaskFiles(
                        haveCalendar: true,
                        labelText: 'End',
                        hintText: '',
                        controller: calendarEndController,
                        startDate: DateTime.parse(calendarStartController.text),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Add employee',
                  weight: FontWeight.w500,
                  paddingBottom: 8.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 3,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const InviteEmployee(), binding: UserBindings());
                        },

                        // => Get.to(
                        //   () => const InviteEmployee(),
                        // ),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(100),
                          color: kSecondaryColor,
                          child: const ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: SizedBox(
                              height: 38,
                              width: 38,
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: Obx(() => ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              itemCount: controller.dummyEmploye.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var data = controller.dummyEmploye[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 7,
                                  ),
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kBlackColor.withOpacity(0.04),
                                        blurRadius: 6,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: RadiusHandler.radius100,
                                        child: Image.asset(
                                          'assets/images/dummy_chat/user.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          align: TextAlign.center,
                                          text: data.email,
                                          size: 12,
                                          maxLines: 1,
                                          overFlow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.dummyEmploye.removeWhere(
                                              (element) => element.email == controller.dummyEmploye[index].email);
                                          setState(() {});
                                        },
                                        child: Image.asset(
                                          kCloseIcon,
                                          color: kPurpleColor,
                                          height: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                MyText(
                  text: 'Task type',
                  weight: FontWeight.w500,
                  paddingBottom: 8,
                ),
                Row(
                  children: [
                    taskType(
                      'Ongoing',
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    taskType(
                      'Urgent',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                MyText(
                  text: 'Add file (optional)',
                  weight: FontWeight.w500,
                  paddingBottom: 8,
                ),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.image,
                      // allowedExtensions: ['jpg', 'pdf', 'doc'],
                    );

                    if (result != null) {
                      files = result.paths.map((path) => File(path!)).toList();
                      setState(() {});

                      // imageURL;

                    } else {
                      // User canceled the picker
                    }
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    color: kSecondaryColor,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: MyText(
                            text: 'Upload here...',
                            size: 12,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(
                        files[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Center(
            child: SizedBox(
              width: Get.width * 0.8,
              child: MyButton(
                haveRoundedEdges: true,
                haveCustomElevation: true,
                onPressed: () async {
                  int time = DateTime.now().microsecondsSinceEpoch;

                  for (int i = 0; i < files.length; i++) {
                    final firebaseStorage = FirebaseStorage.instance
                        .ref()
                        .child('tasks_$time')
                        .child('${DateTime.now().millisecondsSinceEpoch}');
                    UploadTask uploadTask = firebaseStorage.putFile(files[i]);
                    TaskSnapshot taskSnapshot = await uploadTask;

                    taskSnapshot.ref.getDownloadURL().then((value) {
                      setState(() {
                        imageURL.add(value);
                      });
                    });
                  }
                  // print("button pressed");
                  List<dynamic> newTasks = [];
                  for (var element in tasksCollection) {
                    newTasks.add({
                      "task": element.text,
                      "isCompleted": false,
                    });
                  }

                  TaskModel taskModel = TaskModel(
                    title: nameController.text,
                    description: descriptionController.text,
                    start: Timestamp.fromDate(DateTime.parse(calendarStartController.text)),
                    end: Timestamp.fromDate(DateTime.parse(calendarEndController.text)),
                    type: selectedType,
                    status: 'starting',
                    createdBy: userController.uid.value,
                    createdAt: Timestamp.now(),
                    tasks: newTasks,
                    files: imageURL,
                    personWorking: userController.dummyEmploye.length,
                  );

                  if (widget.isEdit) {
                    await FirebaseFirestore.instance
                        .doc((taskController.selectedTask?.path).toString())
                        .set(taskModel.toJson());
                  } else {
                    await FirebaseFirestore.instance
                        .collection(userController.companyType.value)
                        .doc('tasks')
                        .collection("tasks")
                        .doc(time.toString())
                        .set(taskModel.toJson());
                    // log(controller.dummyEmploye.toString());
                    for (var employee in controller.dummyEmploye) {
                      await FirebaseFirestore.instance
                          .collection(userController.companyType.value)
                          .doc('tasks')
                          .collection("tasks")
                          .doc("$time")
                          .collection("users")
                          .doc(employee.userId)
                          .set(employee.toJson());
                      final dio = Dio();

                      try {
                        const url = "https://us-central1-copter-439c8.cloudfunctions.net/sendNotification";
                        await dio.post(
                          url,
                          data: {
                            "uid": employee.userId,
                            "title": "Invited to a task",
                            "body": "${userController.name.value} has invited you to ${nameController.text}",
                            "type": "task",
                            "task": "${userController.companyType.value}/tasks/tasks/$time",
                          },
                        );
                      } on DioError catch (e) {
                        log(e.message);
                      }
                    }
                  }

                  Get.back();
                },
                text: 'Create task',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskType(String taskType) {
    return GestureDetector(
      onTap: () {
        changeSelectedType(taskType);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: selectedType == taskType ? kSecondaryColor : kPrimaryColor,
          borderRadius: RadiusHandler.radius10,
          border: Border.all(
            color: kBorderColor,
            width: 1.0,
          ),
          boxShadow: [
            selectedType != taskType
                ? BoxShadow(
                    color: kSecondaryColor.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 10,
                  )
                : const BoxShadow(),
          ],
        ),
        child: Center(
          child: MyText(
            text: taskType,
            color: selectedType == taskType ? kPrimaryColor : kSecondaryColor,
          ),
        ),
      ),
    );
  }

  void changeSelectedType(String taskType) {
    // print("changing selected type to $taskType");
    setState(() {
      selectedType = taskType;
    });
  }

  void updateControllersForEdit() async {
    dynamic data = await FirebaseFirestore.instance.doc((taskController.selectedTask?.path).toString()).get();

    nameController.value = TextEditingValue(text: data['title']);
    descriptionController.value = TextEditingValue(text: data['description']);
    calendarStartController.value = TextEditingValue(text: data['start']);
    calendarEndController.value = TextEditingValue(text: data['end']);
    changeSelectedType(data['type']);

    tasksCollection.clear();
    for (var task in data['tasks']) {
      tasksCollection.add(TextEditingController(text: task['task']));
    }
  }
}

// ignore: must_be_immutable
class AddTaskFiles extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var labelText, hintText;
  bool? haveLabel, haveCalendar;
  int? maxLines;
  TextEditingController? controller = TextEditingController();

  final DateTime? startDate;

  AddTaskFiles({
    Key? key,
    this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.controller,
    this.haveCalendar = false,
    this.haveLabel = true,
    this.startDate,
  }) : super(key: key);

  @override
  _AddTaskFilesState createState() => _AddTaskFilesState();
}

class _AddTaskFilesState extends State<AddTaskFiles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.haveLabel == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${widget.labelText}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                )
              : const SizedBox(),
          GestureDetector(
            onTap: () => Get.dialog(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    shape: RadiusHandler.roundedRadius16,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: CalendarPopUp(
                        startDate: widget.startDate,
                      ),
                    ),
                  ),
                ],
              ),
            ).then((value) {
              if (value == null) return;
              print("value: $value");
              widget.controller!.text = value.toString().split(' ')[0];
              setState(() => widget.hintText = value.toString().split(' ')[0]);
            }),
            child: TextFormField(
              enabled: !(widget.haveCalendar!),
              maxLines: widget.maxLines!,
              controller: widget.controller,
              style: const TextStyle(
                fontSize: 12,
                color: kBlackColor2,
              ),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(
                  minWidth: widget.haveCalendar == true ? 50.0 : 0.0,
                ),
                prefixIcon: widget.haveCalendar == true
                    ? GestureDetector(
                        onTap: () => Get.dialog(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                shape: RadiusHandler.roundedRadius16,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: CalendarPopUp(startDate: widget.startDate),
                                ),
                              ),
                            ],
                          ),
                        ).then((value) => setState(() => widget.hintText = value)),
                        child: Image.asset(
                          kCalendarIcon,
                          height: 20,
                        ),
                      )
                    : const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                hintText: '${widget.hintText}',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: kBlackColor2,
                ),
                enabledBorder: TextFieldStyling.roundedBorder,
                focusedBorder: TextFieldStyling.roundedBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarPopUp extends StatefulWidget {
  DateTime? startDate;

  CalendarPopUp({this.startDate, Key? key}) : super(key: key);

  @override
  _CalendarPopUpState createState() => _CalendarPopUpState();
}

class _CalendarPopUpState extends State<CalendarPopUp> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: kDarkPurpleColor,
      todayButtonColor: kLightPurpleColor,
      onDayPressed: (DateTime date, List<Event> events) {
        // print("hello");
        // return date;
        Get.back(
          result: date,
        );

        setState(() => _currentDate2 = date);
        Get.isOverlaysOpen == true ? Get.back() : null;

        for (var event in events) {
          if (kDebugMode) {
            print(event.title);
          }
        }
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
      minSelectedDate:
          widget.startDate?.add(const Duration(days: 1)) ?? _currentDate.subtract(const Duration(days: 360)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      prevDaysTextStyle: const TextStyle(
        color: kPurpleColor,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
      inactiveDaysTextStyle: const TextStyle(
        color: kLightGreyColor,
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
        color: kLightGreyColor,
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
          _currentMonth = DateFormat.yMMM().format(date);
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
          height: Get.height * 0.4,
          child: _calendarCarouselNoHeader,
        ),
      ],
    );
  }
}
