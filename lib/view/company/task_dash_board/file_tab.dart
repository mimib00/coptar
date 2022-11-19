import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/tasksController.dart';
import '../../../Models/taskModel.dart';

// ignore: must_be_immutable
class File extends StatefulWidget {
  File({Key? key, required this.data}) : super(key: key);
  final List data;

  @override
  State<File> createState() => _FileState();
}

class _FileState extends State<File> {
  List images=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images = widget.data;

    });
  }
  @override
  Widget build(BuildContext context) {

    // return CustomScrollView(
    //   physics: const BouncingScrollPhysics(),
    //   slivers: [
    //     SliverToBoxAdapter(
    //       child: MyText(
    //         text: 'Photos',
    //         weight: FontWeight.w600,
    //         paddingLeft: 15,
    //         paddingBottom: 10,
    //         paddingTop: 40,
    //       ),
    //     ),
    //     SliverPadding(
    //       padding: const EdgeInsets.symmetric(horizontal: 15),
    //       sliver: StreamBuilder(
    //           stream: FirebaseFirestore.instance
    //               .doc((taskController.selectedTask?.path).toString())
    //               .snapshots(),
    //         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //           var data = snapshot.data!;
    //
    //           // print(data.data().toString());
    //           var task = data;
    //           return SliverGrid(
    //             delegate: SliverChildBuilderDelegate(
    //               (context, index) {
    //                 return ClipRRect(
    //                   borderRadius: RadiusHandler.radius18,
    //                   child: Image.asset(
    //                     task[0],
    //                     fit: BoxFit.cover,
    //                     height: Get.height,
    //                     width: Get.width,
    //                   ),
    //                 );
    //               },
    //               // childCount: snapshot.data,
    //             ),
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3,
    //               mainAxisSpacing: 10,
    //               crossAxisSpacing: 10,
    //               mainAxisExtent: 100,
    //             ),
    //           );
    //         }
    //       ),
    //     ),
    //     SliverToBoxAdapter(
    //       child: MyText(
    //         text: 'Files',
    //         weight: FontWeight.w600,
    //         paddingLeft: 15,
    //         paddingBottom: 10,
    //         paddingTop: 30,
    //       ),
    //     ),
    //     SliverPadding(
    //       padding: const EdgeInsets.symmetric(horizontal: 15),
    //       sliver: SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //           (context, index) {
    //             return FileDownloadTile(
    //               fileName: 'File Name',
    //             );
    //           },
    //           childCount: 6,
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
        // mainAxisExtent: 150,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          width: 200,
          child: Image.network(
            images[index],
            // files[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class FileDownloadTile extends StatelessWidget {
  FileDownloadTile({
    Key? key,
    this.fileName,
  }) : super(key: key);

  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: RadiusHandler.radius10,
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: kBlackColor.withOpacity(0.04),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: RadiusHandler.radius10,
            color: kSecondaryColor.withOpacity(0.1),
          ),
          child: Center(
            child: Image.asset(
              kDocumentIcon,
              height: 20,
            ),
          ),
        ),
        title: MyText(
          text: '$fileName',
          size: 12,
          weight: FontWeight.w500,
        ),
        trailing: GestureDetector(
          onTap: () {},
          child: MyText(
            text: 'Download',
            size: 12,
            color: kGreenColor,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
