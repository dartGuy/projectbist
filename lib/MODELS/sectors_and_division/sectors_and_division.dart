class SectorsAndDivisionModel {
  final String sectorName;
  final List<String> divisions;
  SectorsAndDivisionModel({
    required this.sectorName,
    required this.divisions,
  });
  factory SectorsAndDivisionModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json[json.keys.first]!["Divisions"]!;
    List<String> divisions = data.map((e) => e.toString()).toList();

    return SectorsAndDivisionModel(
        sectorName: json.keys.first, divisions: divisions);
  }
}
