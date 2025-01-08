import 'package:project_bist/PROVIDERS/message_provider/events.dart';
import 'package:project_bist/PROVIDERS/message_provider/message_state.dart';
import 'package:project_bist/core.dart';

import '../../MODELS/message_model/single_chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_client;

import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final escrowsProvider = StateNotifierProvider<BaseProvider<EscrowWithSubmissionPlanModel>, ResponseStatus>((ref) => BaseProvider<EscrowWithSubmissionPlanModel>());

// final escrowsJobsAppliedByResearcherProvider = StateNotifierProvider<BaseProvider<List<String>>, ResponseStatus>((ref) => BaseProvider<List<String>>());

class MessageNotifier extends StateNotifier<ChatStatus> {
  MessageNotifier()
      : super(ChatStatus(
          chatState: ChatState.LOADING,
        ));

  static late io_client.Socket socket;

  connectSocket(BuildContext context) {
    socket = io_client.io(
        Endpoints.BASE_URL,
        io_client.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNewConnection()
            .setExtraHeaders({
              Keys.AUTHORIZATION:
                  "Bearer ${getIt<AppModel>().appCacheBox!.get(AppConst.TOKEN_KEY) ?? "token"}"
            })
            .build());
    print("connect socket");
    socket.onConnect((_) {
      print('connected to server');
    });
    // print("come_online");
    socket.emit(MessageEvent.comeOnline, <String, String>{});
    socket.on(MessageEvent.online, (data) => null);

    /// [print("come_onine__${data}")]
    socket.on(MessageEvent.comeOnlineError, (data) => null);

    /// [print("come_onine__${data}")]
    /// [_____________________HANDLES_CHATS_FETCHING___________________]
    socket.emit(MessageEvent.fetchChats);

    socket.on(MessageEvent.listChat, (data) {
      List<dynamic> chats = data;
      List<SingleChatModel> chatList =
          chats.map((e) => SingleChatModel.fromJson(e)).toList();

      state = ChatStatus(chatState: ChatState.DATA, data: chatList);
    });

    socket.on(MessageEvent.unauthorized, (data) {
      Alerts.openStatusDialog(context,
          isSuccess: false,
          title: "Message Error",
          description: data['message']);
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.loginScreen, (_) => false);
      });
    });
    socket.on(MessageEvent.chatsListError, (data) {
      state = ChatStatus(chatState: ChatState.ERROR, message: data['message']);
    });
    socket.onError((_) {
      print("ERROR_MESSAGE: Unable to connect to server onError()");
    });
    socket.onDisconnect((_) {
      Alerts.openStatusDialog(context,
          isSuccess: false, description: "Check your internet connection");
      Navigator.pop(context);
    });
  }

  void deleteChat(BuildContext context, String chatId) {
    ChatState deleteState = ChatState.LOADING;
    socket.emit("delete:chat", {"chatId": chatId});
    socket.on("deleted:chat", (data) {
      deleteState = ChatState.DATA;
      connectSocket(context);
      Alerts.openStatusDialog(context,
          isSuccess: false,
          isDismissible: false,
          description: "Chat deleted successfully");
      Future.delayed(const Duration(seconds: 1), () async {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });
    });
    socket.on("delet:chat:error", (data) {
      deleteState = ChatState.ERROR;
      Alerts.openStatusDialog(context,
          isSuccess: false, description: data['message']);
    });
  }

  List<SingleChatModel>? getChats() => state.data;

  List<SingleChatModel> searchChatList({String searchQuery = ""}) {
    bool condition(String name) =>
        name.toLowerCase().contains(searchQuery.toLowerCase());
    List<SingleChatModel> result = [
      for (var mss in state.data!)
        if ((condition(mss.user2.fullName))) mss
    ];
    return result;
  }
}

class ChatsProvider {
  static final ApiService _apiService = ApiService();

  static fetchOrCreateChat(BuildContext context,
      {required String recipientId, required String recipientRole}) {
    _apiService
        .apiRequest(context,
            url: Endpoints.FETCH_OR_CREATE_CHAT(recipientId, recipientRole),
            method: Methods.GET,
            loadingMessage: "Checking for messages...")
        .then((value) {
      if (value.status == true) {
        String name = "", avatar = "", chatId = value.data['id'];
        List<Message> messages = [];
        _apiService
            .apiRequest(context,
                url: Endpoints.FETCH_RESEARCHER_PROFILE(recipientId),
                method: Methods.GET,
                loadingMessage: "Getting researcher's profile...")
            .then((value) {
          if (value.status == true) {
            name = value.data["fullName"];
            avatar = value.data['avatar'];
            Navigator.pushNamed(context, ChattingPage.chattingPage,
                arguments: ChattingPageArgument(
                    picturePath: avatar,
                    recipientRole: recipientRole,
                    buddyName: name,
                    userType: UserTypes.researcher,
                    friendId: value.data['id'],
                    chatId: chatId,
                    messagesList: messages));
          }
        });
      }
    });
  }
}
