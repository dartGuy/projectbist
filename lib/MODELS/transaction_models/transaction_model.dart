class TransactionModel {
  final String createdAt,title, reference, status, description;
  final int transactionAmount;
  TransactionModel(
      {required this.createdAt,
      required this.title,
      required this.transactionAmount,
      required this.reference,
      required this.status,
      required this.description});

  factory TransactionModel.fromJson({required Map<String, dynamic> json}) {
    return TransactionModel(
        createdAt: json["createdAt"],
        title: json["title"],
        transactionAmount: json["transactionAmount"],
        reference: json["reference"],
        status: json["status"],
        description: json["description"]);
  }
}
