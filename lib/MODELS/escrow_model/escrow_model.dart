class EscrowModel {
  final String jobName,
      jobType,
      researcherName,
      estimationTechnique,
      jobScope,
      timeline;
  final int escrowAmount;
  EscrowModel(
      {required this.jobName,
      required this.jobType,
      required this.researcherName,
      required this.escrowAmount,
      required this.estimationTechnique,
      required this.jobScope,
      required this.timeline});

  factory EscrowModel.fromJson({required Map<String, dynamic> json}) {
    return EscrowModel(
        jobName: json['jobName'],
        jobType: json['jobType'],
        researcherName: json['researcherName'],
        escrowAmount: json['escrowAmount'],
        estimationTechnique: json['estimationTechnique'],
        jobScope: json['jobScope'],
        timeline: json['timeline']);
  }
}
