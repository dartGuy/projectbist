enum EscrowStatus { ongoing, completed, paused } //declined

class EscrowDetails {
  final String id,
      jobType,
      paymentFor,
      researchName,
      projectFee,
      estimationTechnique,
      scopeOfWork,
      estimatedWorkDuration,
      workTimeline,
      projectTitle,
      projectDescription;
  final EscrowStatus escrowStatus;
  EscrowDetails({
    required this.id,
    required this.jobType,
    required this.paymentFor,
    required this.escrowStatus,
    required this.researchName,
    required this.projectFee,
    required this.estimationTechnique,
    required this.scopeOfWork,
    required this.estimatedWorkDuration,
    required this.workTimeline,
    required this.projectTitle,
    required this.projectDescription,
  });
}
