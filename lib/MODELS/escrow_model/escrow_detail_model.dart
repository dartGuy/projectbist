class EscrowDetailModel {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  String researcherName;
  int escrowAmount;
  int releasedAmount;
  String startDate;
  String endDate;
  String clientId;
  String researcherId;
  JobId jobId;

  EscrowDetailModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.researcherName,
    required this.escrowAmount,
    required this.releasedAmount,
    required this.startDate,
    required this.endDate,
    required this.clientId,
    required this.researcherId,
    required this.jobId,
  });

  factory EscrowDetailModel.fromJson(Map<String, dynamic> json) {
    return EscrowDetailModel(
        id: json['id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        status: json['status'],
        researcherName: json['researcherName'],
        escrowAmount: json['escrowAmount'],
        releasedAmount: json['releasedAmount'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        clientId: json['clientId'],
        researcherId: json['researcherId'],
        jobId: JobId.fromJson(json['jobId']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedAt'] = updatedAt.toIso8601String();
    data['status'] = status;
    data['researcherName'] = researcherName;
    data['escrowAmount'] = escrowAmount;
    data['releasedAmount'] = releasedAmount;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['clientId'] = clientId;
    data['researcherId'] = researcherId;
    data['jobId'] = jobId.toJson();
      return data;
  }
}

class JobId {
  String id;
  DateTime createdAt;
  String jobName;
  String jobTitle;
  String jobType;
  String jobDescription;
  String chapters;
  String estimationTechnique;
  String jobScope;
  int duration;
  String durationType;
  int minBudget;
  int maxBudget;
  int fixedBudget;
  String currency;
  bool openForApplication;
  String clientId;

  JobId({
    required this.id,
    required this.createdAt,
    required this.jobName,
    required this.jobTitle,
    required this.jobType,
    required this.jobDescription,
    required this.chapters,
    required this.estimationTechnique,
    required this.jobScope,
    required this.duration,
    required this.durationType,
    required this.minBudget,
    required this.maxBudget,
    required this.fixedBudget,
    required this.currency,
    required this.openForApplication,
    required this.clientId,
  });

  factory JobId.fromJson(Map<String, dynamic> json) {
    return JobId(
        id: json['id'],
        createdAt: DateTime.parse(json['createdAt']),
        jobName: json['jobName'],
        jobTitle: json['jobTitle'],
        jobType: json['jobType'],
        jobDescription: json['jobDescription'],
        chapters: json['chapters'],
        estimationTechnique: json['estimationTechnique'],
        jobScope: json['jobScope'],
        duration: json['duration'],
        durationType: json['durationType'],
        minBudget: json['minBudget'],
        maxBudget: json['maxBudget'],
        fixedBudget: json['fixedBudget'],
        currency: json['currency'],
        openForApplication: json['openForApplication'],
        clientId: json['clientId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt.toIso8601String();
    data['jobName'] = jobName;
    data['jobTitle'] = jobTitle;
    data['jobType'] = jobType;
    data['jobDescription'] = jobDescription;
    data['chapters'] = chapters;
    data['estimationTechnique'] = estimationTechnique;
    data['jobScope'] = jobScope;
    data['duration'] = duration;
    data['durationType'] = durationType;
    data['minBudget'] = minBudget;
    data['maxBudget'] = maxBudget;
    data['fixedBudget'] = fixedBudget;
    data['currency'] = currency;
    data['openForApplication'] = openForApplication;
    data['clientId'] = clientId;
    return data;
  }
}
