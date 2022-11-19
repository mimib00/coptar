//create task model
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  // 'title': nameController.text,
  // 'description': descriptionController.text,
  // 'start': calendarStartController.text,
  // 'end': calendarEndController.text,
  // 'type': selectedType,
  // 'status': 'pending',
  // 'createdBy': userController.uid,
  // 'createdAt': DateTime.now(),
  // 'tasks': newTasks,
  String title;
  String description;
  Timestamp start;
  Timestamp end;
  String type;
  String status;
  int personWorking;
  DocumentReference? taskId;
  List<dynamic> files;
  String createdBy;
  Timestamp createdAt;
  List<dynamic> tasks;

  TaskModel({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.type,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.tasks,
    required this.files,
    required this.personWorking,
    this.taskId,
  });

  //create factory

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'],
      description: json['description'],
      start: json['start'],
      end: json['end'],
      type: json['type'],
      status: json['status'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      tasks: json['tasks'],
      files: json['files'],
      personWorking: json['personWorking'],
    );
  }

  //create to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start': start,
      'end': end,
      'type': type,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'tasks': tasks,
      'personWorking': personWorking,
      'files': files,
    };
  }

  static TaskModel fromDocumentSnapshot(QueryDocumentSnapshot<Object?> element) {
    return TaskModel(
      taskId: element.reference,
      title: element['title'],
      description: element['description'],
      start: element['start'],
      end: element['end'],
      type: element['type'],
      status: element['status'],
      createdBy: element['createdBy'],
      createdAt: element['createdAt'],
      tasks: element['tasks'],
      files: element['files'],
      personWorking: element['personWorking'],
    );
  }
}
