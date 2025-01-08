import 'package:project_bist/MODELS/institutions_model/faculty_model.dart';

class InstitutionModel {
  String name, institutionType, abbreviation, ownership, website;

  int year;

  List<Faculty> faculties;

  InstitutionModel({
    required this.name,
    required this.institutionType,
    required this.abbreviation,
    required this.ownership,
    required this.website,
    required this.year,
    required this.faculties,
  });

  factory InstitutionModel.fromJson(Map<String, Map<String, dynamic>> json) {
    return InstitutionModel(
      name: json.keys.first,
      institutionType: json[json.keys.first]!['Institution Type'],
      abbreviation: json[json.keys.first]!['Abbreviation'],
      ownership: json[json.keys.first]!['Ownership'],
      website: json[json.keys.first]!['Website'],
      year: json[json.keys.first]!['Year'],
      faculties: (json[json.keys.first]!['Faculties'] as List)
          .map((e) => Faculty.fromJson(e))
          .toList(),
    );
  }
}
