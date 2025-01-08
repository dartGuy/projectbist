class MessageEvent {
  static String chatsListError = "chat:messages:error";
  static String comeOnline = "come:online",
      online = "online",
      comeOnlineError = "come:online:error";


  ///[====================FETCH_CHATS====================]
  static String fetchChats = "fetch:chats",
      listChat = 'list:chats',
      fetchChatsError = "fetch:chats:error";

  ///[====================FETCH_MESSAGES=================]
  static String fetchChatMessages = 'fetch:chat-messages',
      chatMessages = 'chat:messages';

  /// [===================SEND_MESSAGE===================]
  static String sendMessage = "send:message",
      sentMessage = "sent:message",
      sendMessageError = 'send:message:error';

  ///[===================DELETE_MESSAGE===============]
  static String deleteMessages = "delete:chat-messages",
      deletedChatMessages = "deleted:chat-messages",
      deleteChatMessagesError = "delete:chat-messages:error";

  static String unauthorized = "unauthorized";
}
