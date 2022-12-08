import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/images.dart';
import 'package:copter/view/constant/other.dart';
import 'package:copter/view/widget/my_text.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class File extends StatefulWidget {
  const File({Key? key, required this.data}) : super(key: key);
  final List data;

  @override
  State<File> createState() => _FileState();
}

class _FileState extends State<File> {
  List images = [];
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    setState(() {
      images = widget.data;
    });
    super.initState();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      log(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    log(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: images[index],
              height: 200,
              width: 200,
              fit: BoxFit.fill,
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  const uuid = Uuid();
                  final name = uuid.v4();
                  if (Platform.isAndroid) {
                    String appDocDir =
                        await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                    final exists = await Directory("$appDocDir/Coptar").exists();
                    if (!exists) await Directory("$appDocDir/Coptar").create();

                    await FlutterDownloader.enqueue(
                      url: images[index],
                      fileName: "$name.jpeg",
                      savedDir: "$appDocDir/Coptar/",
                      showNotification: true,
                      openFileFromNotification: true,
                    );
                  } else {
                    Directory appDocDir = await getApplicationDocumentsDirectory();
                    final exists = await Directory("${appDocDir.absolute.path}/Coptar/").exists();
                    if (!exists) await Directory("${appDocDir.absolute.path}/Coptar/").create();

                    await FlutterDownloader.enqueue(
                      url: images[index],
                      fileName: "$name.jpeg",
                      savedDir: "${appDocDir.absolute.path}/Coptar/",
                    );
                  }
                },
                child: const Icon(
                  Icons.download_for_offline_outlined,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            )
          ],
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
