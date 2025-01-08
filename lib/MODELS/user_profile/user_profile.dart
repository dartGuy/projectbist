import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/main.dart';

class UserProfile {
  String? id,
      email,
      fullName,
      username,
      phoneNumber,
      avatar,
      role,
      institutionName,
      institutionCategory,
      institutionOwnership,
      faculty,
      department,
      clientType,
      studentType,
      division,
      educationalLevel,
      experience,
      sector;
  bool? identityVerified;

  UserProfile({
    this.id,
    this.email,
    this.fullName,
    this.username,
    this.avatar,
    this.phoneNumber,
    this.role,
    this.institutionName,
    this.institutionCategory,
    this.institutionOwnership,
    this.faculty,
    this.department,
    this.clientType,
    this.studentType,
    this.division,
    this.educationalLevel,
    this.experience,
    this.sector,
    this.identityVerified = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic>? json) => UserProfile(
      id: json?['id'] ?? "id",
      email: json?['email'] ?? "email",
      fullName: json?['fullName'] ?? "fullName",
      username: json?['userName'] ?? "username",
      avatar: json?['avatar'] ?? "avatar",
      phoneNumber: json?['phoneNumber'] ?? "phoneNumber",
      role: json?['role'] ?? "role",
      institutionName: json?["institutionName"] ?? "institutionName",
      institutionCategory:
          json?["institutionCategory"] ?? "institutionCategory",
      institutionOwnership:
          json?["institutionOwnership"] ?? "institutionOwnership",
      faculty: json?["faculty"] ?? "faculty",
      department: json?['department'] ?? "department",
      clientType: json?["clientType"] ?? "clientType",
      studentType: json?['studentType'] ?? "studentType",
      division: json?['division'] ?? "division",
      educationalLevel: json?["educationLevel"] ?? "educationalLevel",
      experience: json?['experience'] ?? "experience",
      identityVerified: json?['identityVerified'] ?? false,
      sector: json?["sector"] ?? "sector");

  @override
  String toString() =>
      "id=$id\nemail=$email\nfullName=$fullName\nusername=$username\navatar=$avatar\nphoneNumber=$phoneNumber\nrole=$role\ninstitutionName=$institutionName\ninstitutionCategory=$institutionCategory\ninstitutionOwnership=$institutionOwnership\nfaculty=$faculty\ndepartment=$department\nclientType=$clientType\nstudentType=$studentType\ndivision=$division\neducationLevel=$educationalLevel\nexperience=$experience\nsector=$sector\n";

  Map<String, dynamic> researcherToJson(UserProfile userProfile) {
    return {
      'experience': userProfile.experience,
      'sector': userProfile.sector,
      'faculty': userProfile.faculty,
      'educationLevel': userProfile.educationalLevel,
      'division': userProfile.division,
      'institutionName': userProfile.institutionName,
      'institutionCategory': userProfile.institutionCategory,
      'institutionOwnership': userProfile.institutionOwnership,
      'department': userProfile.department,
      'avatar': userProfile.avatar,
      'userName': userProfile.username,
      'phoneNumber': userProfile.phoneNumber,
      'fullName': getIt<AppModel>().userProfile!.fullName!
    };
  }

  Map<String, dynamic> professionalToJson(UserProfile userProfile) {
    return {
      'sector': userProfile.sector,
      'division': userProfile.division,
      'avatar': userProfile.avatar,
      'phoneNumber': userProfile.phoneNumber,
      'username': userProfile.username,
      'educationLevel': userProfile.educationalLevel,
    };
  }

  Map<String, dynamic> studentToJson(UserProfile userProfile) {
    return {
      'phoneNumber': userProfile.phoneNumber,
      'userName': userProfile.username,
      'avatar': userProfile.avatar,
      'institutionName': userProfile.institutionName,
      'institutionCategory': userProfile.institutionCategory,
      'institutionOwnership': userProfile.institutionOwnership,
      'department': userProfile.department,
      'faculty': userProfile.faculty,
      'studentType': userProfile.studentType,
    };
  }
}
