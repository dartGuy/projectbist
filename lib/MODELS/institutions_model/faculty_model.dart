class Faculty {
  String name;
  List<String> departments;

  Faculty({
    required this.name,
    required this.departments,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      name: json['Faculty'],
      departments: (json['Departments'] as List)
          .map<String>((d) => d.toString())
          .toList(),
    );
  }
//
  Map<String, dynamic> toJson() {
    return {
      'Faculty': name,
      'Departments': departments,
    };
  }
}
