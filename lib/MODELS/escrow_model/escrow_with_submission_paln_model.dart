class EscrowWithSubmissionPlanModel {
  List<Plan> plans;
  String id;
  String createdAt;
  String updatedAt;
  String status;
  String researcherName;
  int escrowAmount;
  int releasedAmount;
  String startDate;
  String endDate;
  String deletedAt;
  String clientId;
  String researcherId;
  bool isActive;
  JobId? jobId;

  EscrowWithSubmissionPlanModel({
    required this.plans,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.researcherName,
    required this.escrowAmount,
    required this.releasedAmount,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.deletedAt,
    required this.clientId,
    required this.researcherId,
    required this.jobId,
  });

  factory EscrowWithSubmissionPlanModel.fromJson(Map<String, dynamic> json) {
    List rawPlans = json['plans'];
    List<Plan> plans = rawPlans.map((e) => Plan.fromJson(e)).toList();
    return EscrowWithSubmissionPlanModel(
        id: json['id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        status: json['status'],
        researcherName: json['researcherName'],
        escrowAmount: json['escrowAmount'],
        releasedAmount: json['releasedAmount'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        deletedAt: json['deletedAt'] ?? "deletedAt",
        isActive: json['isActive'] ?? false,
        clientId: json['clientId'],
        researcherId: json['researcherId'],
        jobId: json["jobId"]!=null?JobId.fromJson(json["jobId"]):null,
        plans: plans);
    // if (json.containsKey("plans")) {
    //   List plans = json['plans'];
    //   List<Plan> availablePlans = plans.map((e) => Plan.fromJson(e)).toList();
    //   escrowWithSubmissionPlanModel.plans = availablePlans;
    // }
  }
}

class Plan {
  String id;
  String createdAt;
  String updatedAt;
  String name;
  String deliverable;
  String deadline;
  int price;
  String attachment;
  String submissionDate;
  String status;
  bool isPendingSubmission;
  int extensionDuration;
  String extensionDurationType;
  int reviewCount;
  String escrow;

  Plan({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.deliverable,
    required this.deadline,
    required this.price,
    required this.attachment,
    required this.submissionDate,
    required this.status,
    required this.isPendingSubmission,
    required this.extensionDuration,
    required this.extensionDurationType,
    required this.reviewCount,
    required this.escrow,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],
      deliverable: json['deliverable'],
      deadline: json['deadline'],
      price: json['price'],
      attachment: json['attachment'],
      submissionDate: json['submissionDate'],
      status: json['status'],
      isPendingSubmission: json['isPendingSubmission'] ?? true,
      extensionDuration: json['extensionDuration'],
      extensionDurationType: json['extensionDurationType'],
      reviewCount: json['reviewCount']??0,
      escrow: json['escrow'],
    );
  }
}

class JobId {
  String id;
  String createdAt;
  String jobName;
  String jobTitle;
  String status;
  String jobType;
  String jobDescription;
  String chapters;
  String fileName;
  String estimationTechnique;
  String jobScope;
  int duration;
  String durationType;
  int minBudget;
  int maxBudget;
  int fixedBudget;
  String currency;
  bool openForApplication;
  bool isPaused;
  String pauseReason;
  bool isActive;
  String clientId;

  JobId({
    required this.id,
    required this.createdAt,
    required this.jobName,
    required this.jobTitle,
    required this.status,
    required this.jobType,
    required this.jobDescription,
    required this.chapters,
    required this.fileName,
    required this.estimationTechnique,
    required this.jobScope,
    required this.duration,
    required this.durationType,
    required this.minBudget,
    required this.maxBudget,
    required this.fixedBudget,
    required this.currency,
    required this.openForApplication,
    required this.isPaused,
    required this.pauseReason,
    required this.isActive,
    required this.clientId,
  });

  factory JobId.fromJson(Map<String, dynamic>? json) {
    return JobId(
      id: json!['id'],
      createdAt: json['createdAt'],
      jobName: json['jobName'],
      jobTitle: json['jobTitle'],
      status: json['status'],
      jobType: json['jobType'],
      jobDescription: json['jobDescription'],
      chapters: json['chapters'] ?? json['resource'] ?? "attachment_url",
      fileName: json['fileName'],
      estimationTechnique: json['estimationTechnique'],
      jobScope: json['jobScope'],
      duration: json['duration'],
      durationType: json['durationType'],
      minBudget: json['minBudget'] ?? 0,
      maxBudget: json['maxBudget'] ?? 0,
      fixedBudget: json['fixedBudget'] ?? 0,
      currency: json['currency'],
      openForApplication: json['openForApplication'] ?? false,
      isPaused: json['isPaused'] ?? false,
      pauseReason: json['pauseReason'],
      isActive: json['isActive'] ?? false,
      clientId: json['clientId'],
    );
  }
}
