class StudentTopicsModel {
  final String facultyName;
  final List<TopicsListAndDepartmentName> topicsListAndDepartName;

  StudentTopicsModel(
      {required this.facultyName, required this.topicsListAndDepartName});

  factory StudentTopicsModel.fromJson({required Map<String, dynamic> json}) {
    List list = json[json.keys.first]!["Departments"]!;
    List<TopicsListAndDepartmentName> topicsListAndDepartName =
        list.map((e) => TopicsListAndDepartmentName.fromJson(json: e)).toList();
    return StudentTopicsModel(
        facultyName: json.keys.first,
        topicsListAndDepartName: topicsListAndDepartName);
  }
}

class TopicsListAndDepartmentName {
  final String departmentName;
  final List<String> topics;

  TopicsListAndDepartmentName(
      {required this.departmentName, required this.topics});

  factory TopicsListAndDepartmentName.fromJson(
      {required Map<String, dynamic> json}) {
    List list = json["Project Topics"];
    List<String> topics = list.map((e) => e.toString()).toList();
    return TopicsListAndDepartmentName(
        departmentName: json["Department"], topics: topics);
  }
}
