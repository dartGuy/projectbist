import 'package:bot_toast/bot_toast.dart';
import 'package:project_bist/MODELS/message_model/single_message_model.dart';
import 'package:project_bist/PROVIDERS/message_provider/events.dart';
import 'package:project_bist/PROVIDERS/message_provider/message_state.dart';
import 'package:project_bist/core.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_client;

import '../../MODELS/message_model/single_chat_model.dart';
import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageListNotifier extends StateNotifier<MessageStatus> {
  MessageListNotifier({this.data})
      : super(MessageStatus(chatState: ChatState.LOADING, data: data));
  List<Message>? data;
  bool isEmpty = false;
  Message? messageSent;
  Iterable<DateTime> dates() =>
      (state.data ?? []).where((e) => e.id == "id").map((e) => e.createdAt);
  // Iterable<Message> messages() => (state.data ?? []).where((e) => e.id == "id");
  // Map<DateTime, Message> messageDate() =>
  //     Map.fromIterables(dates(), messages());
  Future<ChatState> receivedMessage(io_client.Socket socket) async {
    ChatState receivedState = ChatState.LOADING;
    socket.on(MessageEvent.sentMessage, (data) {
      Message message = Message.fromJson(data)
        ..message = Message.fromJson(data)
            .message
            ?.replaceAll(RegExp(r'^\s+|\s+$'), '');
      dates().toList().sort((a, b) => a.compareTo(b));
      DateTime closestDate = dates().first;
      state.data = [
        for (final Message mss in (state.data ?? []))
          if (mss.createdAt != closestDate) mss
      ];

      state = MessageStatus(
          chatState: state.chatState,
          data: [...(state.data ?? <Message>[]), message]);
    });
    return receivedState;
  }

  void deleteChatMessages(
      BuildContext context,
      io_client.Socket socket,
      String chatId,
      List<String> messagesId,
      void Function() afterDelete) async {
    print("delete messagessss");

    socket.emit(MessageEvent.deleteMessages,
        {"chatId": chatId, "messages": messagesId});
    ChatState chatState = ChatState.LOADING;
    print(messagesId);
    socket.on(MessageEvent.deletedChatMessages, (data) {
      chatState = ChatState.DATA;
      List<Message> data = [
        for (Message message in (state.data ?? []))
          if (!messagesId.contains(message.id)) message
      ];
      state = MessageStatus(data: data);
      afterDelete();
    });
    socket.on(MessageEvent.deleteChatMessagesError, (data) {
      chatState = ChatState.ERROR;
      afterDelete();
      Alerts.openStatusDialog(context,
          isSuccess: false, description: data['message']);
    });
    // print("delete state $chatState");
    // return chatState;
  }

  Future<ChatState> sendMessage(BuildContext context, io_client.Socket socket,
      SendMessageModel sendMessageModel) async {
    ChatState sentState = ChatState.LOADING;
    Message message = Message(
        id: "id",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: "",
        message: sendMessageModel.message,
        sender: getIt<AppModel>().userProfile!.id!,
        receiver: "",
        senderType: "",
        receiverType: "",
        attachment: sendMessageModel.file ?? "attachment",
        attachmentType: (sendMessageModel.file ?? "").split(".").last,
        attachmentName:
            (sendMessageModel.file ?? "").split("/").last.split(".").first,
        sentAt: DateTime.now(),
        chat: "chat");

    state.data = [...(state.data ?? []), message];
    print(sendMessageModel.toJson());
    socket.emit(MessageEvent.sendMessage, sendMessageModel.toJson());
    sentState = ChatState.DATA;
    socket.on(MessageEvent.sendMessageError, (data) {
      sentState = ChatState.ERROR;
      Alerts.openStatusDialog(context,
          isSuccess: false, description: data['message']);
    });
    if (sentState == ChatState.DATA) {
      messageSent = message;
    }
    return sentState;
  }

  void fetchChatMessages(
      BuildContext context, io_client.Socket socket, String chatId,
      {int? limit}) {
    state = MessageStatus(chatState: ChatState.LOADING, data: state.data);
    Map valueMap = {'chatId': chatId};
    if ((state.data ?? []).isNotEmpty) {
      valueMap['limit'] = 6;

      ///[limit ?? 5;]
      valueMap['skip'] = state.data!.length - 1;
    }
    socket.emit(MessageEvent.fetchChatMessages, valueMap);
    socket.on(MessageEvent.chatMessages, (data) {
      Map<String, dynamic> raw = data;
      List<dynamic> messages = raw['messages'];
      List<Message> messageList =
          messages.map((e) => Message.fromJson(e)).toList();

      if (messageList.isEmpty) {
        isEmpty = true;
      }
      List<Message> messagesSorted = [...messageList, ...(state.data ?? [])];
      messagesSorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      Set<String> ids = {};
      List<Message> result = state.data = [];

      for (final Message msg in messagesSorted) {
        if (!ids.contains(msg.id)) {
          result.add(msg);
          ids.add(msg.id);
        }
      }

      state = MessageStatus(chatState: ChatState.DATA, data: result);
    });
    socket.on(MessageEvent.fetchChatsError, (data) {
      state =
          MessageStatus(chatState: ChatState.ERROR, message: data['message']);
      Alerts.openStatusDialog(context,
          isSuccess: false,
          title: "Message Error",
          description: data['message']);
    });
  }
}
