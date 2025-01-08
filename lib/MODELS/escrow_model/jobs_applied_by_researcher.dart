class JobsAppliedByResearcher {
  final String id, jobName;
  JobsAppliedByResearcher({required this.id, required this.jobName});
  factory JobsAppliedByResearcher.fromJson(
      {required Map<String, dynamic> json}) {
    return JobsAppliedByResearcher(id: json["id"], jobName: json["jobName"]);
  }
}
