class ExploreTopicsModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  String? faculty;
  String? discipline;
  String? sector;
  String? division;
  String? topic;
  int? views;
  int? likes;
  Researcher? researcherId;

  ExploreTopicsModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.faculty,
    this.discipline,
    this.sector,
    this.division,
    this.topic,
    this.views,
    this.likes,
    this.researcherId,
  });

  factory ExploreTopicsModel.fromJson(Map<String, dynamic> json) {
    return ExploreTopicsModel(
      id: json['id'] ?? "id",
      createdAt: DateTime.parse(json['createdAt'] ?? "createdAt"),
      updatedAt: DateTime.parse(json['updatedAt'] ?? "updatedAt"),
      type: json['type'] ?? 'type',
      faculty: json['faculty'] ?? 'faculty',
      discipline: json['discipline'] ?? 'discipline',
      sector: json['sector'] ?? 'sector',
      division: json['division'] ?? 'division',
      topic: json['topic'] ?? 'topic',
      views: json['views'] ?? 'views',
      likes: json['likes'] ?? 'likes',
      researcherId: Researcher.fromJson(
        json['researcherId'] ?? 'researcherId',
      ),
    );
  }

  static ExploreTopicsModel defaultTopic() => ExploreTopicsModel.fromJson({
        "id": "65bc239f918b036253db0cc9",
        "createdAt": "2024-02-01T23:05:03.954Z",
        "updatedAt": "2024-02-01T23:05:03.954Z",
        "type": "Student Thesis",
        "faculty": "Education",
        "discipline": "Civil Engineering",
        "sector": "",
        "division": "",
        "topic": "Customer satisfaction",
        "views": 0,
        "likes": 0,
        "researcherId": {
          "fullName": "jamiuadeleke",
          "userName": "Hazelnut",
          "email": "jamiuoluwabusayoadeleke@gmail.com",
          "phoneNumber": "0903004001",
          "faculty": "Accounting and Management",
          "institutionName": "Atiba University",
          "institutionCategory": "University",
          "institutionOwnership": "private",
          "educationLevel": "Ph.d",
          "experience": "7 years",
          "division": "Accounting",
          "sector": "Finance",
          "avatar":
              "https://res.cloudinary.com/dlgf8ok2j/image/upload/profileImage"
        }
      });
}

class Researcher {
  String? fullName;
  String? userName;
  String? email;
  String? phoneNumber;
  String? faculty;
  String? institutionName;
  String? institutionCategory;
  String? institutionOwnership;
  String? educationLevel;
  String? experience;
  String? division;
  String? sector;
  String? avatar;

  Researcher({
    this.fullName,
    this.userName,
    this.email,
    this.phoneNumber,
    this.faculty,
    this.institutionName,
    this.institutionCategory,
    this.institutionOwnership,
    this.educationLevel,
    this.experience,
    this.division,
    this.sector,
    this.avatar,
  });

  factory Researcher.fromJson(Map<String, dynamic> json) {
    return Researcher(
      fullName: json['fullName'] ?? 'fullName',
      userName: json['userName'] ?? 'userName',
      email: json['email'] ?? 'email',
      phoneNumber: json['phoneNumber'] ?? 'phoneNumber',
      faculty: json['faculty'] ?? 'faculty',
      institutionName: json['institutionName'] ?? 'institutionName',
      institutionCategory: json['institutionCategory'] ?? 'institutionCategory',
      institutionOwnership:
          json['institutionOwnership'] ?? 'institutionOwnership',
      educationLevel: json['educationLevel'] ?? 'educationLevel',
      experience: json['experience'] ?? 'experience',
      division: json['division'] ?? 'division',
      sector: json['sector'] ?? 'sector',
      avatar: json['avatar'] ?? 'avatar',
    );
  }
}
