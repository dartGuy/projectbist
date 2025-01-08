/// ============================[JSON ROOT PATH]
String json(String jsonName) => "assets/data/$jsonName.json";

class Jsons {
  static String institutions = json("nigerian_institutions");
  static String sectorsAndDivision = json("sectors_and_divisions");
  static String studentTopics = json("student_topics");
  static String professionalTopics = json("professional_topics");
  static String facultyAndDepartment = json("faculty_department");
}
