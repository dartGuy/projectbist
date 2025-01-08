import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:project_bist/MODELS/sectors_and_division/sectors_and_division.dart';
import 'package:project_bist/UTILS/json_path.dart';

class SectorAndDivisionProvider {
  static Future<List<String>> fetchSectors() async {
    String fileData = await rootBundle.loadString(Jsons.sectorsAndDivision);
    List<dynamic> rawData = jsonDecode(fileData);
    List<SectorsAndDivisionModel> dataList =
        rawData.map((e) => SectorsAndDivisionModel.fromJson(e)).toList();
    List<String> sectors = dataList.map((e) => e.sectorName).toList();
    sectors.sort();
    return sectors;
  }

  static Future<List<String>> fetchDivisions(String sectorName) async {
    String fileData = await rootBundle.loadString(Jsons.sectorsAndDivision);
    List<dynamic> rawData = jsonDecode(fileData);
    List<SectorsAndDivisionModel> dataList = rawData
        .map((e) => SectorsAndDivisionModel.fromJson(e))
        .toList()
        .where((e) => e.sectorName == sectorName)
        .toList();
    List<String> divisions = dataList.map((e) => e.divisions).toList().first;
    divisions.sort();
    return divisions;
  }
}
