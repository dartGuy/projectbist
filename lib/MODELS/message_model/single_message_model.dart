class SendMessageModel {
  final String message, chatId, recipientRole;
  String? file, fileType, fileName, replyTo;

  SendMessageModel({
    required this.message,
    required this.chatId,
    required this.recipientRole,
    this.file,
    this.fileType,
    this.fileName,
    this.replyTo
  });

  Map<String, String> toJson() {
    Map<String, String> data = {
      'message': message,
      'chatId': chatId,
      'recipientRole': recipientRole
    };
    if(file != null){
      data['file'] = file!;
    }
    if(fileType != null){
      data['fileType'] = fileType!;
    }if(fileName != null){
      data['fileName'] = fileName!;
    }
    if(replyTo != null){
      data['replyTo'] = replyTo!;
    }
    data =  Map<String, String>.from(data);
    return data;
  }
}