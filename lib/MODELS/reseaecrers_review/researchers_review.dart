class ResearchersReview {
  final String id, review, researcherId;
  final DateTime createdAt, updatedAt;
  final int rating;
  final ClientsReviewDetail clientId;

  ResearchersReview({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.review,
    required this.rating,
    required this.researcherId,
    required this.clientId,
  });

  factory ResearchersReview.fromJson(Map<String, dynamic> json) {
    return ResearchersReview(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      review: json['review'],
      rating: json['rating'],
      researcherId: json['researcherId'],
      clientId: ClientsReviewDetail.fromJson(json['clientId']),
    );
  }
}

class ClientsReviewDetail {
  final String id,
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

  ClientsReviewDetail({
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

  factory ClientsReviewDetail.fromJson(Map<String, dynamic> json) {
    return ClientsReviewDetail(
      id: json['id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      faculty: json['faculty'],
      department: json['department'],
      clientType: json['clientType'],
      division: json['division'],
      sector: json['sector'],
      educationLevel: json['educationLevel'],
      institutionName: json['institutionName'],
      institutionCategory: json['institutionCategory'],
      institutionOwnership: json['institutionOwnership'],
      institutionType: json['institutionType'],
      studentType: json['studentType'],
      accountStatus: json['accountStatus'],
      avatar: json['avatar'],
      loginSession: json['loginSession'],
      identityNumber: json['identityNumber']??'identityNumber',
      identityVerified: json['identityVerified'],
    );
  }
}
