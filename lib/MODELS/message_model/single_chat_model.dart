class SingleChatModel {
  final String id, user1Type, user2Type;
  final DateTime createdAt, updatedAt;
  final User user1, user2;
  List<Message> messages;

  SingleChatModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user1Type,
    required this.user2Type,
    required this.user1,
    required this.user2,
    required this.messages,
  });

  factory SingleChatModel.fromJson(Map<String, dynamic> json) {
    return SingleChatModel(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user1Type: json['user1Type'],
      user2Type: json['user2Type'],
      user1: User.fromJson(json['user1']),
      user2: User.fromJson(json['user2']),
      messages: List<Message>.from(json['messages'].map((x) =>
          Message.fromJson(x)
            ..message = Message.fromJson(x)
                .message
                ?.replaceAll(RegExp(r'^\s+|\s+$'), '')))
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
    );
  }
}

class User {
  String id, avatar, fullName, userName, email, role;
  String? clientType;

  User({
    required this.id,
    required this.avatar,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.role,
    this.clientType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "id",
      avatar: json['avatar'] ?? "",
      fullName: json['fullName'] ?? "",
      userName: json['userName'] ?? "",
      email: json['email'] ?? "",
      role: json['role'] ?? "",
      clientType: json['clientType'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'role': role,
      'clientType': clientType,
    };
  }
}

class Message {
  String? message;
  final String id,
      status,
      senderType,
      receiverType,
      attachment,
      attachmentType,
      attachmentName,
      chat,
      sender,
      receiver;
  final DateTime createdAt, updatedAt, sentAt;
  final DateTime? deliveredAt, readAt, deletedAt;
  final Message? replyTo;
  bool? isActive;

  Message(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      required this.message,
      required this.sender,
      required this.receiver,
      required this.senderType,
      required this.receiverType,
      required this.attachment,
      required this.attachmentType,
      required this.attachmentName,
      required this.sentAt,
      required this.chat,
      this.deletedAt,
      this.deliveredAt,
      this.readAt,
      this.replyTo,
      this.isActive});

  Message copyWith(Message message) {
    return message;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
      message: json['message'],
      sender: json['sender'],
      receiver: json['receiver'],
      senderType: json['senderType'],
      receiverType: json['receiverType'],
      attachment: json['attachment'] ?? '',
      attachmentType: json['attachmentType'] ?? '',
      attachmentName: json['attachmentName'] ?? '',
      sentAt: DateTime.parse(json['sentAt']),
      deletedAt: DateTime.tryParse(json['deletedAt']),
      deliveredAt: json['deliveredAt'] != ""
          ? DateTime.parse(json['deliveredAt'])
          : null,
      readAt: json['readAt'] != "" ? DateTime.parse(json['readAt']) : null,
      chat: json['chat'],
      isActive: json['isActive'] ?? true,
      replyTo:
          json['replyTo'] != null ? Message.fromJson(json['replyTo']) : null,
    );
  }
}
