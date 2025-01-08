class NotificationModel {
  final String id;
  final String title;
  final String type;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, message: $message, createdAt: $createdAt)';
  }
}
