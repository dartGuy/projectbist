import "package:intl/intl.dart";

class ResearcherJobModel {
  String id,
      jobName,
      jobTitle,
      jobType,
      jobDescription,
      fileName,
      chapters,
      resource,
      estimationTechnique,
      currency,
      jobScope,
      durationType,
      createdAt;
  bool openForApplication;
  int duration, minBudget, maxBudget, numberOfApplications, fixedBudget;
  Client clientId;

  ResearcherJobModel({
    required this.id,
    required this.createdAt,
    required this.jobName,
    required this.jobTitle,
    required this.jobType,
    required this.jobDescription,
    required this.chapters,
    required this.resource,
    required this.estimationTechnique,
    required this.jobScope,
    required this.duration,
    required this.durationType,
    required this.minBudget,
    required this.maxBudget,
    required this.fileName,
    required this.fixedBudget,
    required this.currency,
    required this.openForApplication,
    required this.clientId,
    required this.numberOfApplications,
  });

  factory ResearcherJobModel.fromJson(Map<String, dynamic> json) {
    return ResearcherJobModel(
      id: json['id'],
      createdAt: DateFormat.yMMMMd()
          .format(DateTime.parse(json['createdAt']))
          .toString(),
      jobName: json['jobName'] ?? 'jobName',
      jobTitle: json['jobTitle'] ?? 'jobTitle',
      jobType: json['jobType'] ?? 'jobType',
      jobDescription: json['jobDescription'] ?? 'jobDescription',
      chapters: json['chapters'] ?? 'chapters',
      resource: json['resource'] ?? 'resource',
      fileName: json['fileName'] ?? 'fileName',
      estimationTechnique: json['estimationTechnique'] ?? 'estimationTechnique',
      jobScope: json['jobScope'] ?? 'jobScope',
      duration: json['duration'] ?? 'duration',
      durationType: json['durationType'] ?? 'durationType',
      minBudget: json['minBudget'] ?? 0,
      maxBudget: json['maxBudget'] ?? 0,
      fixedBudget: json['fixedBudget'] ?? 0,
      currency: json['currency'] ?? 'currency',
      openForApplication: json['openForApplication'] ?? false,
      clientId: Client.fromJson(json['clientId']),
      numberOfApplications: json['numberOfApplications'] ?? 0,
    );
  }
}

class Client {
  String id,
      fullName,
      userName,
      email,
      phoneNumber,
      faculty,
      department,
      clientType,
      division,
      sector,
      educationLevel,
      institutionName,
      institutionCategory,
      institutionOwnership,
      institutionType,
      studentType,
      accountStatus,
      avatar,
      loginSession,
      identityNumber;
  bool identityVerified;

  Client({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.faculty,
    required this.department,
    required this.clientType,
    required this.division,
    required this.sector,
    required this.educationLevel,
    required this.institutionName,
    required this.institutionCategory,
    required this.institutionOwnership,
    required this.institutionType,
    required this.studentType,
    required this.accountStatus,
    required this.avatar,
    required this.loginSession,
    required this.identityNumber,
    required this.identityVerified,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? 'phoneNumber',
      faculty: json['faculty'].isEmpty ? "faculty" : json['faculty'],
      department: json['department'] ?? 'department',
      clientType: json['clientType'] ?? 'clientType',
      division: json['division'].isEmpty ? "division" : json['division'],
      sector: json['sector'] ?? 'sector',
      educationLevel: json['educationLevel'] ?? 'educationLevel',
      institutionName: json['institutionName'].isEmpty
          ? "institutionNames"
          : json['institutionName'],
      institutionCategory: json['institutionCategory'] ?? 'institutionCategory',
      institutionOwnership:
          json['institutionOwnership'] ?? 'institutionOwnership',
      institutionType: json['institutionType'] ?? 'institutionType',
      studentType: json['studentType'] ?? 'studentType',
      accountStatus: json['accountStatus'] ?? 'accountStatus',
      avatar: json['avatar'] ?? 'avatar',
      loginSession: json['loginSession'] ?? 'loginSession',
      identityNumber: json['identityNumber'] ?? 'identityNumber',
      identityVerified: json['identityVerified'] ?? false,
    );
  }
}
