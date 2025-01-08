import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:project_bist/PROVIDERS/switch_user.dart";
import "package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart";
import "package:project_bist/UTILS/constants.dart";
import "package:project_bist/MODELS/job_model/applicants_data.dart";

class JobModel {
  String? id,
      clientId,
      jobScope,
      chapters,
      resource,
      jobName,
      jobTitle,
      fileName,
      jobType,
      jobDescription,
      estimationTechnique,
      durationType,
      currency,
      createdAt;
  bool? openForApplication;
  int? numberOfApplications, duration, minBudget, maxBudget, fixedBudget;
  List<ResearcherData>? researcherApplicantsData;
  JobModel(
      {this.id,
      this.chapters,
      this.resource,
      this.clientId,
      this.jobScope,
      this.createdAt,
      this.jobName,
      this.fileName,
      this.jobTitle,
      this.jobType,
      this.jobDescription,
      this.estimationTechnique,
      this.duration,
      this.durationType,
      this.minBudget,
      this.maxBudget,
      this.fixedBudget,
      this.currency,
      this.openForApplication,
      this.numberOfApplications,
      this.researcherApplicantsData});

  factory JobModel.fromJson(Map<String, dynamic> json) {
    JobModel jobModel = JobModel(
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
        estimationTechnique:
            json['estimationTechnique'] ?? 'estimationTechnique',
        jobScope: json['jobScope'] ?? 'jobScope',
        duration: json['duration'] ?? 'duration',
        fileName: json['fileName'] ?? 'fileName',
        durationType: json['durationType'] ?? 'durationType',
        minBudget: json['minBudget'] ?? 'minBudget',
        maxBudget: json['maxBudget'] ?? 'maxBudget',
        fixedBudget: json['fixedBudget'] ?? 'fixedBudget',
        currency: json['currency'] ?? 'currency',
        openForApplication: json['openForApplication'] ?? 'openForApplication',
        clientId: json['clientId'] ?? 'clientId',
        numberOfApplications:
            json['numberOfApplications'] ?? 0,
        researcherApplicantsData: null);
    if (json.containsKey("applications")) {
      List applications = json['applications'] ?? [];
      List<ResearcherData> researcherApplications =
          applications.map((e) => ResearcherData.fromJson(e)).toList();
      jobModel.researcherApplicantsData = researcherApplications;
      [];
    }

    return jobModel;
  }

  Map<String, dynamic> toJson(
      {required WidgetRef ref,
      required bool isFixedBudget,
      bool? isProjectFee}) {
    Map<String, dynamic> mapData = {
      'jobName': jobName,
      'jobTitle': (jobTitle ?? "").isEmpty ? "--" : jobTitle,
      'jobDescription': jobDescription,
      'jobType': jobType,
      'estimationTechnique': estimationTechnique,
      'jobScope': jobScope,
      'fileName': fileName,
      'duration': duration,
      'durationType': durationType,
      'currency': AppConst.COUNTRY_CURRENCY,
    };
    if (ref.watch(switchUserProvider) == UserTypes.professional) {
      if ((resource ?? "").replaceAll("--", "").isNotEmpty) {
        mapData.addEntries({
          "resource": resource,
        }.entries);
      }
    }

    if (ref.watch(switchUserProvider) == UserTypes.student) {
      mapData.addEntries({
        "chapters": chapters,
      }.entries);
    }
    if (isFixedBudget == true) {
      mapData.addEntries({
        isProjectFee == true ? "projectFee" : 'fixedBudget': fixedBudget
      }.entries);
    } else {
      mapData.addEntries({
        'maxBudget': maxBudget,
        'minBudget': minBudget,
      }.entries);
    }

    return mapData;
  }
}
