import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copter/Controllers/user_controller.dart';
import 'package:get/get.dart';

import '../Models/task_model.dart';

//create get controller

class TaskController extends GetxController {
  UserController userController = Get.find();
  Rx<List<TaskModel>> allTasks = Rx<List<TaskModel>>([]);
  Rx<List<TaskModel>> urgentTasks = Rx<List<TaskModel>>([]);
  Rx<List<TaskModel>> ongoingTasks = Rx<List<TaskModel>>([]);

  Rx<List<TaskModel>> startingTasks = Rx<List<TaskModel>>([]);
  Rx<List<TaskModel>> completedTasks = Rx<List<TaskModel>>([]);

  Rx<List<TaskModel>> runningTasks = Rx<List<TaskModel>>([]);

  DocumentReference? selectedTask;
  late String selectedTaskList;

  @override
  void onInit() {
    allTasks.bindStream(allTaskStream());
    buildLists();
    super.onInit();
  }

  allTaskStream() {
    try {
      return FirebaseFirestore.instance
          .collection(userController.companyType.value)
          .doc('tasks')
          .collection('tasks')
          .orderBy('end', descending: false)
          .snapshots()
          .map((QuerySnapshot query) {
        List<TaskModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(TaskModel.fromDocumentSnapshot(element));
        }
        return retVal;
      });
    } catch (e) {
      return null;
    }
  }

  //
  // Stream<List<TaskModel>> urgentTaskStream() {
  //   return FirebaseFirestore.instance
  //       .collection(userController.companyType)
  //       .doc('tasks')
  //       .collection('tasks')
  //       .where('type', isEqualTo: 'Urgent')
  //       .where('status', isNotEqualTo: 'completed')
  //       // .orderBy('end', descending: false)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<TaskModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TaskModel.fromDocumentSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }
  //
  // Stream<List<TaskModel>> startingTaskStream() {
  //   return FirebaseFirestore.instance
  //       .collection(userController.companyType)
  //       .doc('tasks')
  //       .collection('tasks')
  //       .where('status', isEqualTo: 'starting')
  //       // .orderBy('end', descending: false)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<TaskModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TaskModel.fromDocumentSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }
  //
  // Stream<List<TaskModel>> runningTaskStream() {
  //   return FirebaseFirestore.instance
  //       .collection(userController.companyType)
  //       .doc('tasks')
  //       .collection('tasks')
  //       .where('status', isEqualTo: 'running')
  //       // .orderBy('end', descending: false)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<TaskModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TaskModel.fromDocumentSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }
  //
  // Stream<List<TaskModel>> completedTaskStream() {
  //   return FirebaseFirestore.instance
  //       .collection(userController.companyType)
  //       .doc('tasks')
  //       .collection('tasks')
  //       .where('status', isEqualTo: 'completed')
  //       // .orderBy('end', descending: false)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<TaskModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TaskModel.fromDocumentSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }
  //
  // Stream<List<TaskModel>> ongoingTaskStream() {
  //   return FirebaseFirestore.instance
  //       .collection(userController.companyType)
  //       .doc('tasks')
  //       .collection('tasks')
  //       .where('type', isEqualTo: 'Ongoing')
  //       .where('status', isNotEqualTo: 'completed')
  //       // .orderBy('end', descending: false)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<TaskModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(TaskModel.fromDocumentSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }

  getList() {
    var taskList = allTasks;
    //filter alltasks list

    switch (selectedTaskList.toLowerCase()) {
      case 'alltasks':
        {
          taskList = allTasks;

          break;
        }
      case 'ongoing':
        {
          taskList = ongoingTasks;
          break;
        }
      case 'urgent':
        {
          taskList = urgentTasks;
          break;
        }
      case 'starting':
        {
          taskList = startingTasks;
          break;
        }
      case 'running':
        {
          taskList = runningTasks;
          break;
        }
      case 'completed':
        {
          taskList = completedTasks;
          break;
        }
      default:
        {
          taskList = allTasks;
        }
    }
    return taskList;
  }

  void buildLists() {
    allTasks.listen((event) {
      urgentTasks.value = event.where((element) => element.type == 'Urgent').toList();
      ongoingTasks.value = event.where((element) => element.type == 'Ongoing').toList();
      startingTasks.value = event.where((element) => element.status == 'starting').toList();
      runningTasks.value = event.where((element) => element.status == 'running').toList();
      completedTasks.value = event.where((element) => element.status == 'completed').toList();
    });
  }

  void editTask() {}
}
