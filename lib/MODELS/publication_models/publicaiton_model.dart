class PublicationModel {
  final String type,
      id,
      currency,
      status,
      title,
      name,
      abstractText,
      failedReason;
  final int numOfRef, likes, views;
  final double price, uniquenessScore;
  final DateTime createdAt;
  List<String>? tags, owners;
  final bool isVisible, verified;
  bool? hasBeenLiked;
  final ResearcherId researcherId;

  PublicationModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.type,
    required this.abstractText,
    this.tags,
    this.owners,
    required this.isVisible,
    required this.numOfRef,
    required this.price,
    this.hasBeenLiked,
    required this.failedReason,
    required this.currency,
    required this.status,
    required this.verified,
    required this.uniquenessScore,
    required this.name,
    required this.views,
    required this.likes,
    required this.researcherId,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    PublicationModel publicationModel = PublicationModel(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      type: json['type'],
      abstractText: json['abstract'],
      tags: [],
      owners: [],
      isVisible: json['isVisible'],
      numOfRef: json['numOfRef'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      hasBeenLiked: json['hasBeenLiked'],
      failedReason: json['failedReason'] ?? "",
      status: json['status'],
      verified: json['verified'],
      uniquenessScore: json['uniquenessScore'].toDouble(),
      name: json['name'],
      views: json['views'],
      likes: json['likes'],
      researcherId: ResearcherId.fromJson(json['researcherId']),
    );
    if (json['tags'].isNotEmpty && json['tags'].runtimeType == List) {
      List tags = json['tags'];
      List<String> tagsData = tags.map((e) => e.toString()).toList();
      publicationModel.tags = tagsData;
    } else if (json['tags'].runtimeType == String) {
      publicationModel.tags = [json['tags']];
    }
    if (json['owners'].isNotEmpty && json['owners'].runtimeType == List) {
      List owners = json['owners'];
      List<String> ownersData = owners.map((e) => e.toString()).toList();
      publicationModel.owners = ownersData;
    } else if (json['owners'].runtimeType == String) {
      publicationModel.tags = [json['owners']];
    }
    return publicationModel;
  }
}

class ResearcherId {
  final String id,
      fullName,
      userName,
      email,
      phoneNumber,
      faculty,
      institutionName,
      institutionCategory,
      institutionOwnership,
      educationLevel,
      experience,
      division,
      sector,
      accountStatus,
      avatar,
      loginSession,
      identityNumber;
  bool identityVerified;

  ResearcherId({
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
    required this.identityNumber,
    required this.identityVerified,
  });

  factory ResearcherId.fromJson(Map<String, dynamic> json) {
    return ResearcherId(
      id: json['id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      faculty: json['faculty'],
      institutionName: json['institutionName'] ?? 'institutionName',
      institutionCategory: json['institutionCategory'] ?? 'institutionCategory',
      institutionOwnership: json['institutionOwnership'],
      educationLevel: json['educationLevel'] ?? 'educationLevel',
      experience: json['experience'] ?? 'experience',
      division: json['division'] ?? 'division',
      sector: json['sector'] ?? 'sector',
      accountStatus: json['accountStatus'] ?? 'accountStatus',
      avatar: json['avatar'] ?? 'avatar',
      loginSession: json['loginSession'] ?? 'loginSession',
      identityNumber: json['identityNumber'] ?? 'identityNumber',
      identityVerified: json['identityVerified'] ?? 'identityVerified',
    );
  }
}
