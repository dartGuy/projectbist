// ignore_for_file: constant_identifier_names

import 'package:project_bist/MODELS/message_model/single_chat_model.dart';

enum ChatState { LOADING, DATA, ERROR }

class ChatStatus {
  String? message;
  ChatState? chatState;
  List<SingleChatModel>? data;

  ChatStatus({this.message, this.chatState, this.data});
}

class MessageStatus {
  String? message;
  ChatState? chatState;
  List<Message>? data;

  MessageStatus({this.message, this.chatState, this.data});
}
