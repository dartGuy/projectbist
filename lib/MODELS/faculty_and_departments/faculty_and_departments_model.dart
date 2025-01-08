// FacultyAndDepartmentModel facultyAndDepartmentModelFromJson(String str) => FacultyAndDepartmentModel.fromJson(json.decode(str));

// String facultyAndDepartmentModelToJson(FacultyAndDepartmentModel data) => json.encode(data.toJson());

class FacultyAndDepartmentModel {
  final String faculty;
  final List<String> departments;

  FacultyAndDepartmentModel({
    required this.faculty,
    required this.departments,
  });

  factory FacultyAndDepartmentModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json[json.keys.first]['Departments'];

    List<String> departments = [];

    for (int i = 0; i < data.length; i++) {
      departments.add(data[i]);
    }

    return FacultyAndDepartmentModel(
        faculty: json.keys.first, departments: departments);
  }
}

class Faculty {
  final List<Department> departments;

  Faculty({
    required this.departments,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        departments: List<Department>.from(
            json["Departments"].map((x) => Department.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Departments": List<dynamic>.from(departments.map((x) => x.toJson())),
      };
}

class Department {
  final String department;
  final List<String> projectTopics;

  Department({
    required this.department,
    required this.projectTopics,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        department: json["Department"],
        projectTopics: List<String>.from(json["Project Topics"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Department": department,
        "Project Topics": List<dynamic>.from(projectTopics.map((x) => x)),
      };
}
