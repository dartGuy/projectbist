class BankModel {
  final String code, name;
  BankModel({required this.code, required this.name});
  factory BankModel.fromJson(Map<String, dynamic> json) =>
      BankModel(code: json["code"], name: json["name"]);
}
