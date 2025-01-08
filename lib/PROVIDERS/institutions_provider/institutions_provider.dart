import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:project_bist/MODELS/institutions_model/faculty_model.dart';
import 'package:project_bist/MODELS/institutions_model/institutions_model.dart';
import 'package:project_bist/UTILS/json_path.dart';

class InstitutionsProvider {
  static Future<List<String>> fetchInstitutions(
      {required String institutionType, required String ownership}) async {
    String raw = await rootBundle.loadString(Jsons.institutions);
    List<dynamic> rawList = jsonDecode(raw);
    List<Map<String, Map<String, dynamic>>> dataList = rawList
        .map((e) => e.cast<String, Map<String, dynamic>>()
            as Map<String, Map<String, dynamic>>)
        .toList();
    List<InstitutionModel> institutions =
        dataList.map((e) => InstitutionModel.fromJson(e)).toList();
    List<String> institutionNames = institutions
        .where((e) =>
            e.institutionType == institutionType && e.ownership == ownership)
        .toList()
        .map((e) => e.name)
        .toList();
    institutionNames.sort();
    return institutionNames;
  }
 

  static Future<List<String>> fetchFaculties(
      {required String institutionType,
      required String ownership,
      required String institutionName}) async {
    String raw = await rootBundle.loadString(Jsons.institutions);
    List<dynamic> rawList = jsonDecode(raw);
    List<Map<String, Map<String, dynamic>>> dataList = rawList
        .map((e) => e.cast<String, Map<String, dynamic>>()
            as Map<String, Map<String, dynamic>>)
        .toList();
    List<InstitutionModel> institutions =
        dataList.map((e) => InstitutionModel.fromJson(e)).toList();
    List<String> faculties = institutions
        .where((e) =>
            e.institutionType == institutionType &&
            e.ownership == ownership &&
            e.name == institutionName)
        .toList()
        .map((e) => e.faculties)
        .toList()
        .map((e) => e.map((e) => e.name).toList())
        .toList()
        .first;

    faculties.sort();
    return faculties;
  }

  static Future<List<String>> fetchDepartments(
      {required String institutionType,
      required String ownership,
      required String institutionName,
      required String faculty}) async {
    String raw = await rootBundle.loadString(Jsons.institutions);
    List<dynamic> rawList = jsonDecode(raw);
    List<Map<String, Map<String, dynamic>>> dataList = rawList
        .map((e) => e.cast<String, Map<String, dynamic>>()
            as Map<String, Map<String, dynamic>>)
        .toList();
    List<InstitutionModel> institutions =
        dataList.map((e) => InstitutionModel.fromJson(e)).toList();
    List<Faculty> faculties = institutions
        .where((e) =>
            e.institutionType == institutionType &&
            e.ownership == ownership &&
            e.name == institutionName)
        .toList()
        .map((e) => e.faculties)
        .toList()
        .first;
    List<String> departments = faculties
        .where((e) => e.name == faculty)
        .toList()
        .map((e) => e.departments)
        .toList()
        .first;
    departments.sort();
    return departments;
  }
}
