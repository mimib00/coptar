import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/back_button.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tasks_tabs/all.dart';
import 'tasks_tabs/ongoing.dart';
import 'tasks_tabs/urgent.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> with SingleTickerProviderStateMixin {
  final List<String>? tabs = [
    'All',
    'Urgent',
    'Ongoing',
  ];

  final List<Widget>? tabsData = const [
    All(),
    Urgent(),
    Ongoing(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Navigator.canPop(context) ? backButton() : null,
        title: MyText(
          text: 'Task',
          weight: FontWeight.w500,
          color: kBlackColor2,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: Center(
              child: Image.asset(
                kSearchIcon,
                height: 20,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(0, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: TabBar(
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15),
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
            ],
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) => [
          const SliverAppBar(),
        ],
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          controller: _controller,
          children: tabsData!,
        ),
      ),
    );
  }
}
