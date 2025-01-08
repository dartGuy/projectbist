import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';
import 'package:project_bist/MODELS/topics_model/student_topics_model.dart';
import 'package:project_bist/UTILS/json_path.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../MODELS/faculty_and_departments/faculty_and_departments_model.dart';

final studentsTopicProvider =
    StateNotifierProvider<StudentsTopicsProvider, List<String>>(
        (_) => StudentsTopicsProvider());

class StudentsTopicsProvider extends StateNotifier<List<String>> {
  StudentsTopicsProvider() : super(<String>[]);
  static final AppMethods<String> pagination = AppMethods();
  Future fetchStudentsExploreTopic(
      {required String facultyName,
      required String departmentName,
      int? paginationNo}) async {
    List<String> topics = [];
    Future.delayed(const Duration(milliseconds: 100), () async {
      String file = await rootBundle.loadString(Jsons.studentTopics);
      List<dynamic> list = jsonDecode(file);
      List<StudentTopicsModel> data =
          list.map((e) => StudentTopicsModel.fromJson(json: e)).toList();
      List<StudentTopicsModel> studentTopics = data
          .where((e) => e.facultyName
              .split(" ")
              .toList()
              .any((e) => ("${facultyName}s").contains(e)))
          .toList();
      for (int i = 0; i < studentTopics.length; i++) {
        StudentTopicsModel studentTopic = studentTopics[i];
        for (int j = 0; j < studentTopic.topicsListAndDepartName.length; j++) {
          TopicsListAndDepartmentName ss =
              studentTopic.topicsListAndDepartName[j];
          if (ss.departmentName == departmentName) {
            topics = ss.topics;
          }
        }
      }
    }).then((value) {
      topics.sort();
      state = pagination.paginateList(
          paginationNo: paginationNo ?? 10, itemList: topics);
      // print("STATE LENGTH");
      // print(state.length);
      var data = state.map((e) => ExploreTopicsModel(topic: e, type: "admin"));
      // print("DATA LENGTH");
      // print(data.length);
      // if ((getIt<AppModel>().topicsList ?? []).isNotEmpty) { //all is not admin
      //   getIt<AppModel>().topicsList!.addAll(data.toList());
      //   getIt<AppModel>().topicsList!.shuffle();
      // }
      // getIt<AppModel>().topicsList = [
      //   ...getIt<AppModel>().topicsList ?? [],
      //   ...data.toList()
      // ];
      // (getIt<AppModel>().topicsList ?? []).toSet().addAll(data);
      // print("LENGTHHHHHHHHHH");
      // getIt<AppModel>().topicsList!.length;
    });
  }
}

class FacultyAndDepartmentProvider {
  static Future<List<String>> fetchFaculties() async {
    String fileData = await rootBundle.loadString(Jsons.facultyAndDepartment);
    List<dynamic> rawData = jsonDecode(fileData);
    List<FacultyAndDepartmentModel> dataList =
        rawData.map((e) => FacultyAndDepartmentModel.fromJson(e)).toList();
    List<String> faculties = dataList.map((e) => e.faculty).toList();
    faculties.remove('Others');
    faculties.sort();
    faculties.add('Others');
    return faculties;
  }

  static Future<List<String>> fetchDepartments(String faculty) async {
    String fileData = await rootBundle.loadString(Jsons.facultyAndDepartment);
    List<dynamic> rawData = jsonDecode(fileData);
    List<FacultyAndDepartmentModel> dataList = rawData
        .map((e) => FacultyAndDepartmentModel.fromJson(e))
        .toList()
        .where((e) => e.faculty == faculty)
        .toList();
    List<String> departments =
        dataList.map((e) => e.departments).toList().first;
    departments.sort();
    return departments;
  }
}
