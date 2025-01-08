class ResearcherData {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  Researcher researcherId;
  String clientId;
  String jobId;

  ResearcherData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.researcherId,
    required this.clientId,
    required this.jobId,
  });

  factory ResearcherData.fromJson(Map<String, dynamic> json) {
    return ResearcherData(
      id: json['id'] ?? "",
      createdAt: DateTime.parse(json['createdAt'] ?? ""),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ""),
      researcherId: Researcher.fromJson(json['researcherId']),
      clientId: json['clientId'] ?? 'clientId',
      jobId: json['jobId'] ?? 'jobId',
    );
  }
}

class Researcher {
  String id;
  String fullName;
  String userName;
  String email;
  String phoneNumber;
  String faculty;
  String institutionName;
  String institutionCategory;
  String institutionOwnership;
  String educationLevel;
  String experience;
  String division;
  String sector;
  String accountStatus;
  String avatar;
  String loginSession;
//  String identityNumber;
  bool identityVerified;

  Researcher({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.faculty,
    required this.institutionName,
    required this.institutionCategory,
    required this.institutionOwnership,
    required this.educationLevel,
    required this.experience,
    required this.division,
    required this.sector,
    required this.accountStatus,
    required this.avatar,
    required this.loginSession,
    //  required this.identityNumber,
    required this.identityVerified,
  });

  factory Researcher.fromJson(Map<String, dynamic> json) {
    return Researcher(
      id: json['id'] ?? "",
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      faculty: json['faculty'],
      institutionName: json['institutionName'],
      institutionCategory: json['institutionCategory'],
      institutionOwnership: json['institutionOwnership'],
      educationLevel: json['educationLevel'],
      experience: json['experience'],
      division: json['division'],
      sector: json['sector'],
      accountStatus: json['accountStatus'],
      avatar: json['avatar'],
      loginSession: json['loginSession'],
      // identityNumber: json['identityNumber'],
      identityVerified: json['identityVerified'],
    );
  }
}
