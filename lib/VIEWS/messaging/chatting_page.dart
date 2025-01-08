import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:project_bist/MODELS/message_model/single_message_model.dart';
import 'package:project_bist/PROVIDERS/message_provider/chats_provider.dart';
import 'package:project_bist/PROVIDERS/message_provider/message_provider.dart';
import 'package:project_bist/PROVIDERS/message_provider/message_state.dart';
import 'package:project_bist/VIEWS/messaging/researcher_view_client_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../MODELS/message_model/single_chat_model.dart';
import '../../main.dart';

class ChattingPageArgument {
  final String picturePath, buddyName, friendId, recipientRole;
  String? chatId;
  final UserTypes? userType;
  List<Message>? messagesList;
  final User? user;

  ChattingPageArgument({
    required this.picturePath,
    required this.recipientRole,
    required this.buddyName,
    required this.userType,
    required this.friendId,
    this.user,
    this.chatId,
    this.messagesList,
  });
}

class ChattingPage extends ConsumerStatefulWidget {
  ChattingPageArgument? chattingPageArgument;

  ChattingPage({super.key, this.chattingPageArgument});

  static const String chattingPage = "chattingPage";

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends ConsumerState<ChattingPage> {
  bool beginSearch = false;
  late ScrollController scrollController;
  bool _isAtBottom = false;

  ///[user scrolled to the end of screen]
  bool contains9Digit = false, containsEmail = false;
  bool atTop = false;
  String attachmentFile = "", attachmentFileFromCloudinary = "";

  List<String> messagesIdList = [];
  @override
  Widget build(BuildContext context) {
    ref.read(chatsProvider.notifier).connectSocket(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return onBackButtonPressed();
        },
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox.expand(
                  child: switch (attachmentFile.isNotEmpty) {
                true => Container(
                    decoration: BoxDecoration(
                        color: AppThemeNotifier.themeColor(context)
                            .scaffoldBackgroundColor),
                    child: Center(child: Builder(builder: (context) {
                      String fileType =
                          attachmentFile.split("/").last.split(".").last;
                      return SingleChildScrollView(
                          child: Column(children: [
                        if (fileType == "png" || fileType == "jpg")
                          Image.file(File(attachmentFile))
                        else
                          Image.asset(ImageOf.chatAttachment, height: 75.sp),
                        YMargin(20.sp),
                        TextOf(attachmentFile.split("/").last, 20.sp, 7),
                      ]));
                    }))),
                _ => Column(
                    children: [
                      switch (beginSearch == true) {
                        true => searchMwssageInChatTextField(context),
                        _ => Container(
                            decoration: BoxDecoration(
                                color: AppThemeNotifier.themeColor(context)
                                    .scaffoldBackgroundColor,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: -5,
                                    color: AppColors.grey1,
                                    offset: Offset(0, 5),
                                  ),
                                ]),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.sp, vertical: 8.sp),
                              child: switch (messagesIdList.isEmpty) {
                                true => appBarOfChatMateProfile(context),
                                _ => appBarOfDelete_Reply_And_MessageInfo()
                              },
                            ))
                      },
                      ref.watch(switchUserProvider) != UserTypes.researcher
                          ? clientGeneratePaymentWithResearcherButton(context)
                          : const SizedBox.shrink(),
                      Expanded(
                          child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox.expand(
                            child: ListView.builder(
                              controller: scrollController,
                              // physics: const BouncingScrollPhysics(),
                              itemCount:
                                  (ref.watch(messageListProvider).data ?? [])
                                      .length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                Message chat =
                                    ((ref.watch(messageListProvider)).data ??
                                        [])[index];
                                bool fromMe = chat.sender ==
                                    getIt<AppModel>().userProfile!.id!;
                                int lastIndex =
                                    ((ref.watch(messageListProvider)).data ??
                                                [])
                                            .length -
                                        1;
                                bool isAdded = false;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (index == 0) rebuildMessaged(),
                                    Row(
                                      mainAxisAlignment: fromMe == true
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            buildMessageItem(chat, fromMe,
                                                onLongPress: () {
                                              if (messagesIdList
                                                  .contains(chat.id)) {
                                                messagesIdList.remove(chat.id);
                                              } else {
                                                messagesIdList.add(chat.id);
                                              }
                                              setState(() {
                                                isAdded = messagesIdList
                                                    .contains(chat.id);
                                              });
                                            }),
                                            YMargin(
                                                index == lastIndex ? 0.1.sh : 0)
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
              }),
              beginSearch == false && messagesIdList.isEmpty
                  ? Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SizedBox(
                          height: 0.21.sh,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color:
                                          AppThemeNotifier.themeColor(context)
                                              .scaffoldBackgroundColor),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TypeMessageInputField(
                                            messageInputController:
                                                messageInputController,
                                            onTapPickFile: () {
                                              getIt<AppModel>().uploadFile(
                                                  context,
                                                  allowedExtensions: [
                                                    "docx",
                                                    "pdf",
                                                    "txt",
                                                    "pptx",
                                                    "ppt",
                                                    "jpg",
                                                    "jpeg",
                                                    "png",
                                                    "mp4"
                                                  ]).then((value) {
                                                filePath = value?.path??'';
                                                UploadToCloudinaryProvider
                                                        .uploadDocument(context,
                                                            localFilePath:
                                                                value!.path,
                                                            loadingMessage:
                                                                "Please wait...\nHandlig upload  file")
                                                    .then((value) {
                                                  setState(() {
                                                    attachmentFile = value;
                                                  });
                                                });
                                              });
                                            },
                                            replyMessage: replyMessage,
                                            sentReplyMessage: replyMessage !=
                                                    null
                                                ? replyMessage!.sender ==
                                                        getIt<AppModel>()
                                                            .userProfile!
                                                            .id
                                                    ? "You"
                                                    : widget
                                                        .chattingPageArgument!
                                                        .buddyName
                                                : null,
                                            onCancelReply: () {
                                              replyMessage = null;
                                              setState(() {});
                                            },
                                            sendEnabled: (messageInputController
                                                        .text
                                                        .trim()
                                                        .isNotEmpty ||
                                                    attachmentFile
                                                        .isNotEmpty) &&
                                                contains9Digit == false &&
                                                containsEmail == false,
                                            onTapField: () {
                                              scrollToEnd(scrollController);
                                            },
                                            onChanged: (String? value) {
                                              print(messageInputController
                                                  .text.length);
                                              print(0.8.sw);
                                              if (contains9DigitNumber(
                                                      value ?? "") ==
                                                  true) {
                                                setState(() {
                                                  contains9Digit = true;
                                                });
                                              } else {
                                                setState(() {
                                                  contains9Digit = false;
                                                });
                                              }
                                              if (containsEmailAddress(
                                                      value ?? "") ==
                                                  true) {
                                                setState(() {
                                                  containsEmail = true;
                                                });
                                              } else {
                                                setState(() {
                                                  containsEmail = false;
                                                });
                                              }
                                              setState(() {});
                                            },
                                            onTap: () {
                                              ref
                                                  .read(messageListProvider
                                                      .notifier)
                                                  .sendMessage(
                                                      context,
                                                      MessageNotifier.socket,
                                                      SendMessageModel(
                                                          message:
                                                              messageInputController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r'^\s+|\s+$'),
                                                                      ''),
                                                          chatId: widget
                                                              .chattingPageArgument!
                                                              .chatId!,
                                                          file: attachmentFile,
                                                          replyTo:
                                                              replyMessage?.id,
                                                          fileType:
                                                              attachmentFile
                                                                  .split(".")
                                                                  .last,
                                                          fileName:
                                                              filePath
                                                                  .split("/")
                                                                  .last
                                                                  .split(".")
                                                                  .first,
                                                          recipientRole: "_"))
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              messageInputController.clear();
                                              attachmentFile = "";
                                              replyMessage = null;
                                              setState(() {});
                                              scrollToEnd(scrollController);
                                              setState(() {});
                                            }),
                                        if (contains9Digit == true ||
                                            containsEmail == true)
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.sp),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          contains9Digit == true
                                                              ? "Phone number sharing is not allowed!!"
                                                              : "Email sharing is not allowed!!",
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color:
                                                                  Colors.red)))
                                                ],
                                              ))
                                      ]))
                            ],
                          ),
                        ),
                        _isAtBottom == false
                            ? Padding(
                                padding: EdgeInsets.all(15.sp),
                                child: InkWell(
                                  onTap: () {
                                    scrollToEnd(scrollController);
                                  },
                                  child: Card(
                                    elevation: 10,
                                    color: AppColors.blueLite,
                                    surfaceTintColor:
                                        const Color.fromARGB(255, 87, 115, 169),
                                    shadowColor:
                                        const Color.fromARGB(255, 87, 115, 169),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(200.r)),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: IconOf(Icons.keyboard_arrow_down,
                                          size: 25.sp, color: AppColors.white),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  ///[Search message in chat textfield]
  Padding searchMwssageInChatTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InputField(
          hintText: "Search for anything...",
          fillColor: AppColors.brown1(context),
          autofocus: true,
          hintColor:
              AppThemeNotifier.colorScheme(context).primary == AppColors.white
                  ? AppColors.grey1
                  : AppColors.grey3,
          onChanged: (value) {
            setState(() {});
          },
          radius: 10.r,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
          enabledBorderColor: AppColors.brown1(context),
          focusedBorderColor: AppColors.brown1(context),
          prefixIcon: IconOf(Icons.search,
              size: 23.sp,
              color: AppThemeNotifier.colorScheme(context).primary ==
                      AppColors.white
                  ? AppColors.grey1
                  : AppColors.grey3),
          suffixIconConstraints:
              BoxConstraints(maxWidth: 0.2.sw, minWidth: 0.2.sw),
          suffixIcon: InkWell(
              onTap: () {
                if (_searchController.text.isEmpty) {
                  beginSearch = false;
                } else {
                  _searchController.clear();
                }
                setState(() {});
              },
              child: _searchController.text.isNotEmpty
                  ? const IconOf(Icons.close)
                  : Container(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 5.sp),
                      child: Center(
                        child: TextOf(
                          "Close",
                          12.sp,
                          5,
                          color: AppColors.white,
                        ),
                      ))),
          fieldController: _searchController),
    );
  }

  /// [Brown buitton for clienmt to generate payment wioth researcher]
  InkWell clientGeneratePaymentWithResearcherButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context, ClientGeneratePayment.clientGeneratePayment,
            arguments: UserProfile(
                id: widget.chattingPageArgument!.friendId,
                avatar: widget.chattingPageArgument!.picturePath,
                fullName: widget.chattingPageArgument!.buddyName));
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          color: AppColors.brown,
          child: Center(
              child: TextOf(
            "Generate Payment",
            16.sp,
            4,
            color: AppColors.white,
          ))),
    );
  }

  /// [My chat mate's profile pic and name, plus more icon]
  Row appBarOfChatMateProfile(BuildContext context) {
    return Row(children: [
      Row(children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: IconOf(Icons.arrow_back,
              color: AppThemeNotifier.colorScheme(context).primary,
              size: 25.sp),
        ),
        XMargin(10.sp),
        buildProfileImage(
            radius: 48.sp,
            fontSize: 20.sp,
            fontWeight: 6,
            imageUrl: widget.chattingPageArgument!.picturePath,
            fullNameTobSplit: widget.chattingPageArgument!.buddyName),
        XMargin(10.sp),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
                context,
                ResearcherViewClientProfileScreen
                    .researcherViewClientProfileScreen,
                arguments: widget.chattingPageArgument!.user);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextOf(widget.chattingPageArgument!.buddyName, 16, 5),
              TextOf("Online", 14, 4),
            ],
          ),
        )
      ]),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              showCustomTooltip(context);
            },
            child: IconOf(
              Icons.more_vert_outlined,
              size: 24.sp,
              color: AppThemeNotifier.colorScheme(context).primary,
            ),
          )
        ],
      ))
    ]);
  }

  /// [This helps user to take action on a message]
  Row appBarOfDelete_Reply_And_MessageInfo() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            messagesIdList.clear();
            setState(() {});
          },
          child: IconOf(Icons.arrow_back,
              color: AppThemeNotifier.colorScheme(context).primary,
              size: 25.sp),
        ),
        XMargin(10.sp),
        TextOf("${messagesIdList.length.toString()}  selected", 20.sp, 6),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (messagesIdList.length == 1)
              Tooltip(
                  message: "Reply",
                  child: InkWell(
                      onTap: () {
                        replyMessage = (ref.read(messageListProvider).data ??
                                [])
                            .firstWhere((e) => e.id == messagesIdList.first);
                        messagesIdList.clear();
                        setState(() {});
                      },
                      child: IconOf(Icons.reply, size: 25.sp))),
            XMargin(25.sp),
            if (messagesIdList.length == 1 &&
                ((ref.read(messageListProvider).data!)
                            .firstWhere((e) => e.id == messagesIdList.first)
                            .message ??
                        "")
                    .isNotEmpty)
              Tooltip(
                  message: "Copy",
                  child: InkWell(
                      child: IconOf(Icons.copy, size: 22.sp),
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: (ref.read(messageListProvider).data ?? [])
                                .firstWhere((e) => e.id == messagesIdList.first)
                                .message!));
                        messagesIdList.clear();
                        setState(() {});
                        // BotToast.showText(
                        //     text: "Copied to clipboard...",
                        //     textStyle: TextStyle(
                        //         fontSize: 17.sp, fontWeight: FontWeight.w400));
                      })),
            if (messagesIdList.length == 1 &&
                ((ref.read(messageListProvider).data!)
                            .firstWhere((e) => e.id == messagesIdList.first)
                            .message ??
                        "")
                    .isNotEmpty)
              XMargin(25.sp),
            Tooltip(
                message: "Delete",
                child: InkWell(
                    child: IconOf(Icons.delete_outline_outlined, size: 25.sp),
                    onTap: () {
                      setState(() {
                        deleteState = null;
                      });
                      ref.read(messageListProvider.notifier).deleteChatMessages(
                          context,
                          MessageNotifier.socket,
                          widget.chattingPageArgument!.chatId!,
                          messagesIdList,
                          afterDelete);
                      // Future.delayed(Duration(seconds: ));
                      //     .then((value) {
                      //   messagesIdList.clear();
                      //   deleteState = value;
                      //   setState(() {});
                      // })
                    })),
            XMargin(25.sp),
            Tooltip(
                message: "Info",
                child: IconOf(Icons.info_outline, size: 25.sp)),
            XMargin(15.sp),
          ],
        ))
      ],
    );
  }

  void showCustomTooltip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.topRight,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 186.sp,
            child: Container(
              margin: EdgeInsets.only(right: 10.sp),
              decoration: BoxDecoration(
                  color: AppThemeNotifier.themeColor(context)
                      .scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.r)),
              child: ListView.separated(
                shrinkWrap: true,
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    index == 0
                        ? setState(() {
                            beginSearch = true;
                          })
                        : Alerts.optionalDialog(context,
                            text:
                                "Are you sure you want to delete your chat with ${widget.chattingPageArgument!.buddyName}?",
                            onTapLeft: () {
                            Navigator.pop(context);
                            ref.read(chatsProvider.notifier).deleteChat(
                                context, widget.chattingPageArgument!.chatId!);
                          });
                  },
                  child: Row(
                    children: [
                      TextOf(
                        index == 0 ? "Search" : "Delete chat",
                        16.sp,
                        4,
                        color:
                            AppThemeNotifier.colorScheme(context).onSecondary,
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => AppDivider(),
                itemCount: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  late StateNotifierProvider<MessageListNotifier, MessageStatus>
      messageListProvider;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    messageListProvider =
        StateNotifierProvider<MessageListNotifier, MessageStatus>(
      (ref) {
        return MessageListNotifier(
            data: widget.chattingPageArgument!.messagesList);
      },
    );
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        scrollToEnd(scrollController);
      }
    });
    scrollController = ScrollController();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
      //ref.read(messageListProvider.notifier).setMessages(widget.chattingPageArgument!.messagesList!);
      if (widget.chattingPageArgument!.chatId != null) {
        ref.read(messageListProvider.notifier).fetchChatMessages(context,
            MessageNotifier.socket, widget.chattingPageArgument!.chatId!,
            limit: 5);
      }
      ref
          .watch(messageListProvider.notifier)
          .receivedMessage(MessageNotifier.socket)
          .then((_) {
        scrollToEnd(scrollController);
        setState(() {});
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels == 0) {
        // setState(() {
        //   limit = limit + 10;
        //   atTop = true;
        // });
        ref.read(messageListProvider.notifier).fetchChatMessages(context,
            MessageNotifier.socket, widget.chattingPageArgument!.chatId!,
            limit: 5);
      } else {
        atTop = false;
      }
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        // User has scrolled to the bottom
        setState(() {
          _isAtBottom = true;
        });
      } else {
        // User is not at the bottom
        setState(() {
          _isAtBottom = false;
        });
      }
    });
    setState(() {
      messageInputController = TextEditingController();
      messageFieldController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    messageFieldController.dispose();
    messageInputController.dispose();
    scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  late TextEditingController messageFieldController;
  final replySplitter = LineSplitter();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController messageInputController = TextEditingController();

  ChatState? deleteState;

  ///[Message being replied to]
  Message? replyMessage;
  
  String filePath = '';

  ///[Each Message Box]
  Widget buildMessageItem(Message message, bool isFromMe,
      {void Function()? onLongPress}) {
    String query = _searchController.text;
    List<TextSpan> textSpans = [];
    RegExp exp = RegExp(query, caseSensitive: false);
    Iterable<Match> matches = exp.allMatches(message.message ?? "");

    int lastMatchEnd = 0;

    for (Match match in matches) {
      // Add the non-matching part before the match
      if (match.start > lastMatchEnd) {
        textSpans.add(
          TextSpan(
            text: (message.message ?? "").substring(lastMatchEnd, match.start),
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp),
          ),
        );
      }

      // Add the matching part with a different color
      textSpans.add(TextSpan(
        text: (message.message ?? "").substring(match.start, match.end),
        style: TextStyle(
            color: AppColors.yellow3,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp),
      ));

      lastMatchEnd = match.end;
    }

    // Add the non-matching part after the last match
    if (lastMatchEnd < (message.message ?? "").length) {
      textSpans.add(TextSpan(
        text: (message.message ?? "").substring(lastMatchEnd),
        style: const TextStyle(color: AppColors.white),
      ));
    }
    const splitter = LineSplitter();
    bool idAdded = messagesIdList.contains(message.id);
    return InkWell(
        onLongPress: onLongPress!,
        onTap: messagesIdList.isNotEmpty ? onLongPress : null,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
            crossAxisAlignment:
                isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                width: 0.99.sw,
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                // padding: EdgeInsets.all(idAdded == true ? 4.sp : 0),
                margin: EdgeInsets.all(1.5.sp),
                //width: idAdded == true ? 0.9.sw : null,
                /// [Handle when the message is selected to be deleted or replied]
                decoration: BoxDecoration(
                    color: idAdded == true
                        ? AppColors.primaryColor.withOpacity(0.4)
                        : null),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.sp, 8.sp, 8.sp, 2.sp),
                  child: Column(
                    crossAxisAlignment: isFromMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message.replyTo != null)
                        SizedBox(
                          width: 0.65.sw,
                          child: Container(
                            padding: EdgeInsets.all(4.sp),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isFromMe == true
                                        ? const Color.fromARGB(
                                            255, 70, 108, 184)
                                        : Color.lerp(const Color(0xff74A3B7),
                                            AppColors.white, 0.8)!),
                                color: isFromMe == true
                                    ? const Color.fromARGB(255, 70, 108, 184)
                                    : Color.lerp(const Color(0xff74A3B7),
                                        AppColors.white, 0.8)!,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.r),
                                    topLeft: Radius.circular(10.r))),
                            child: replyBox(
                                replyMessage: message.replyTo!,
                                color: Color.lerp(
                                    (isFromMe == true
                                        ? const Color.fromARGB(
                                            255, 70, 108, 184)
                                        : Color.lerp(const Color(0xff74A3B7),
                                            AppColors.white, 0.8)!),
                                    AppColors.black,
                                    0.3),
                                sentReplyMessage: message.replyTo != null
                                    ? message.replyTo!.sender ==
                                            getIt<AppModel>().userProfile!.id
                                        ? "You"
                                        : widget.chattingPageArgument!.buddyName
                                    : null),
                          ),
                        ),
                      if (message.attachment
                          .replaceAll("attachment", "")
                          .isNotEmpty)
                        fileMessageWidget(context, message, isFromMe,
                            borderRadius: message.replyTo != null
                                ? BorderRadius.circular(0)
                                : null,
                            padding: message.replyTo != null ? 10.sp : null),
                      Row(
                        mainAxisAlignment: isFromMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: (message.attachment
                                            .replaceAll("attachment", "")
                                            .isNotEmpty ||
                                        isTextLengthy(
                                            0.5,
                                            splitter
                                                .convert(message.message ?? "")
                                                .reduce((a, b) =>
                                                    a.length > b.length
                                                        ? a
                                                        : b),
                                            TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp),
                                            context) ||
                                        message.replyTo != null)
                                    ? 0.65.sw
                                    : (isTextLengthy(
                                            0.2,
                                            splitter
                                                .convert(
                                                    (message.message ?? ""))
                                                .reduce((a, b) =>
                                                    a.length > b.length
                                                        ? a
                                                        : b),
                                            TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp),
                                            context)
                                        ? null
                                        : 0.25.sw),
                                padding: EdgeInsets.symmetric(
                                    vertical: (message.message ?? "").isEmpty
                                        ? 4
                                        : 16.sp,
                                    horizontal: 10.sp),
                                decoration: BoxDecoration(
                                    color: isFromMe == true
                                        ? AppColors.primaryColor
                                        : const Color(0xff74A3B7),
                                    border: Border.all(
                                        color: isFromMe == true
                                            ? AppColors.primaryColor
                                            : const Color(0xff74A3B7)),
                                    borderRadius: (message.attachment
                                                .replaceAll("attachment", "")
                                                .isNotEmpty ||
                                            message.replyTo != null)
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(10.r),
                                            bottomLeft: Radius.circular(10.r))
                                        : BorderRadius.circular(10.r)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10.sp,
                                          top: (textSpans.isEmpty ||
                                                  (message.message ?? "")
                                                      .isEmpty)
                                              ? 10.sp
                                              : 0),
                                      child: (textSpans.isEmpty ||
                                              (message.message ?? "").isEmpty)
                                          ? const SizedBox.shrink()
                                          : RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: textSpans,
                                              ),
                                            ),
                                    ),
                                    (textSpans.isEmpty ||
                                            (message.message ?? "").isEmpty)
                                        ? const SizedBox.shrink()
                                        : YMargin(3.sp),
                                  ],
                                ),
                              ),
                              !isFromMe
                                  ? YMargin(2.sp)
                                  : Positioned(
                                      bottom: 10.sp,
                                      right: 10.sp,
                                      child: IconOf(
                                          switch (message.status) {
                                            "sent" => Icons.check,
                                            "delivered" =>
                                              Icons.done_all_rounded,
                                            "read" => Icons.done_all_rounded,
                                            _ => Icons.history
                                          },
                                          color: switch (message.status) {
                                            "read" => AppColors.white,
                                            _ => AppColors.grey2
                                          },
                                          size: 15.sp),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: TextOf(
                    timeago.format(message.sentAt) == "a moment ago"
                        ? "now"
                        : timeago.format(message.sentAt),
                    14.sp,
                    4),
              ),
            ]));
  }

  /// [Handles back button to close seaching of messages in the page, plus closes attachment preview page on sending an atachment included message]
  bool onBackButtonPressed() {
    if (beginSearch == true ||
        attachmentFile.isNotEmpty ||
        messagesIdList.isNotEmpty) {
      messagesIdList.clear();
      setState(() {
        beginSearch = false;
        attachmentFile = "";
      });
      return false;
    } else {
      return true;
    }
  }

  void afterDelete() {
    messagesIdList.clear();
    setState(() {});
  }

  /// [Syncing prev messages on user scroll to the top of the page]
  rebuildMessaged() {
    return switch (
        ref.read(messageListProvider).chatState == ChatState.LOADING ||
            (atTop &&
                (ref.read(messageListProvider).chatState == ChatState.DATA))) {
      false => const SizedBox.shrink(),
      true => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YMargin(10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                    dimension: 20.sp,
                    child: const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 3,
                    )),
                XMargin(15.sp),
                TextOf("Syncing previous chats. This may take a while...",
                    14.sp, 4)
              ],
            ),
          ],
        )
    };
  }

  void scrollToEnd(ScrollController scrollController) {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  // void showSendMessageBottomSheet(String filePath) {
  //   String fileType = filePath.split("/").last.split(".").last;
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) => Container(
  //           padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               YMargin(30.sp),
  //               Row(
  //                 children: [TextOf("Add message", 17.sp, 5)],
  //               ),
  //               YMargin(10.sp),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     bottom: MediaQuery.of(context).viewInsets.bottom),
  //                 child: Column(
  //                   children: [
  //                     TypeMessageInputField(
  //                         messageInputController: messageInputController,
  //                         onTapPickFile: () {
  //                           Navigator.pop(context);
  //                           getIt<AppModel>().uploadFile(context,
  //                               allowedExtensions: [
  //                                 "docx",
  //                                 "pdf",
  //                                 "txt",
  //                                 "pptx",
  //                                 "jpg",
  //                                 "png",
  //                                 ""
  //                               ]).then((value) {
  //                             setState(() {
  //                               attachmentFile = value!.path;
  //                             });
  //                             showSendMessageBottomSheet(attachmentFile);
  //                           });
  //                         },
  //                         sendEnabled:
  //                             messageInputController.text.trim().isNotEmpty &&
  //                                 contains9Digit == false &&
  //                                 containsEmail == false,
  //                         onTapField: () {
  //                             scrollController.animateTo(
  //                               scrollController.position.maxScrollExtent,
  //                               duration: const Duration(milliseconds: 100),
  //                               curve: Curves.linear);
  //                         },
  //                         onChanged: (String? value) {
  //                           if (contains9DigitNumber(value ?? "") == true) {
  //                             setState(() {
  //                               contains9Digit = true;
  //                             });
  //                           } else {
  //                             setState(() {
  //                               contains9Digit = false;
  //                             });
  //                           }
  //                           if (containsEmailAddress(value ?? "") == true) {
  //                             setState(() {
  //                               containsEmail = true;
  //                             });
  //                           } else {
  //                             setState(() {
  //                               containsEmail = false;
  //                             });
  //                           }
  //                           setState(() {});
  //                         },
  //                         onTap: () {
  //                           if (!attachmentFileFromCloudinary
  //                                   .contains("http") &&
  //                               attachmentFileFromCloudinary.isNotEmpty) {
  //                             UploadToCloudinaryProvider.uploadDocument(context,
  //                                     localFilePath: attachmentFile,
  //                                     loadingMessage:
  //                                         "Handling uploaded file...")
  //                                 .then((value) {
  //                               setState(() {
  //                                 attachmentFileFromCloudinary = value;
  //                               });
  //                               ref
  //                                   .read(messageListProvider.notifier)
  //                                   .sendMessage(
  //                                       context,
  //                                       MessageNotifier.socket,
  //                                       SendMessageModel(
  //                                           message:
  //                                               messageInputController.text,
  //                                           chatId: widget
  //                                               .chattingPageArgument!.chatId!,
  //                                           recipientRole: "_",
  //                                           file: filePath,
  //                                           fileName: filePath.split("/").last,
  //                                           fileType: filePath
  //                                               .split("/")
  //                                               .last
  //                                               .split(".")
  //                                               .last))
  //                                   .then((_) {});
  //                                   ref.read(chatsProvider.notifier).connectSocket(context);
  //                             });
  //                           } else {
  //                             ref
  //                                 .read(messageListProvider.notifier)
  //                                 .sendMessage(
  //                                     context,
  //                                     MessageNotifier.socket,
  //                                     SendMessageModel(
  //                                         message: messageInputController.text,
  //                                         chatId: widget
  //                                             .chattingPageArgument!.chatId!,
  //                                         recipientRole: "_",
  //                                         file: filePath,
  //                                         fileName: filePath.split("/").last,
  //                                         fileType: filePath
  //                                             .split("/")
  //                                             .last
  //                                             .split(".")
  //                                             .last))
  //                                 .then((_) {});
  //                           }
  //                           scrollController.animateTo(
  //                               scrollController.position.maxScrollExtent,
  //                               duration: const Duration(milliseconds: 100),
  //                               curve: Curves.linear);
  //                           messageInputController.clear();
  //                           setState(() {});
  //                         }),
  //                     if (contains9Digit == true)
  //                       Row(
  //                         children: [
  //                           XMargin(10.sp),
  //                           const Text(
  //                               "Exchanging of phone number outside this app isn't allowed!",
  //                               style: TextStyle(color: Colors.red)),
  //                         ],
  //                       ),
  //                     if (containsEmail == true)
  //                       Row(
  //                         children: [
  //                           XMargin(10.sp),
  //                           const Text(
  //                               "Exchanging of email outside this app isn't allowed",
  //                               style: TextStyle(color: Colors.red)),
  //                         ],
  //                       )
  //                   ],
  //                 ),
  //               ),
  //               if (contains9Digit == true)
  //                 Row(
  //                   children: [
  //                     XMargin(10.sp),
  //                     const Text(
  //                         "Exchanging of phone number outside this app isn't allowed!",
  //                         style: TextStyle(color: Colors.red)),
  //                   ],
  //                 ),
  //               if (containsEmail == true)
  //                 Row(
  //                   children: [
  //                     XMargin(10.sp),
  //                     const Text(
  //                         "Exchanging of email outside this app isn't allowed",
  //                         style: TextStyle(color: Colors.red)),
  //                   ],
  //                 )
  //             ],
  //           )));
  // }
}

bool contains9DigitNumber(String text) {
  RegExp phoneRegExp = RegExp(r'\b\d{8,}\b');
  return phoneRegExp.hasMatch(text);
}

bool containsEmailAddress(String text) {
  RegExp regExp = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
    caseSensitive: false,
  );
  return regExp.hasMatch(text);
}

double downloadProgress = 0;

///[On top of Message Box (buildMessageItem())]
Widget fileMessageWidget(BuildContext context, Message message, bool isFromMe,
    {double? padding, BorderRadius? borderRadius}) {
  return Container(
    width: 0.65.sw,
    padding: EdgeInsets.symmetric(vertical: padding ?? 16.sp),
    decoration: BoxDecoration(
        border: Border.all(
            color: isFromMe == true
                ? const Color.fromARGB(255, 70, 108, 184)
                : Color.lerp(const Color(0xff74A3B7), AppColors.white, 0.8)!),
        color: isFromMe == true
            ? const Color.fromARGB(255, 70, 108, 184)
            : Color.lerp(const Color(0xff74A3B7), AppColors.white, 0.8)!,
        borderRadius: borderRadius ??
            BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(10.r))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
              flex: 1,
              child: Image.asset(ImageOf.chatAttachment,
                  height: 30.sp,
                  color: isFromMe == false
                      ? Color.lerp(
                          const Color(0xff74A3B7), AppColors.white, 0.03)
                      : null)),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Flexible(
                  child: TextOf(
                    "${message.attachment.split("/").last.split(".").first}.",
                    14.sp,
                    4,
                    align: TextAlign.left,
                    color: isFromMe == true ? AppColors.white : AppColors.grey4,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                TextOf(
                  message.attachment.split("/").last.split(".").last,
                  14.sp,
                  4,
                  align: TextAlign.left,
                  color: isFromMe == true ? AppColors.white : AppColors.grey4,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    AppMethods.downloadAndOpenFile(message.attachment,
                        onReceiveProgress: (received, total) {
                      if (total != -1) {
                        downloadProgress = (received / total) * 100;
                      }
                    },
                        attachmentName: message.attachmentName,
                        createdAt: message.createdAt.toString(),
                        attachmentType: message.attachmentType);
                  },
                  child: AppMethods.isDownloaded(message.attachment!)
                      ? IconOf(Icons.check_circle,
                          color: AppColors.green, size: 30.sp)
                      : Image.asset(ImageOf.chatDownload,
                          height: 30.sp,
                          color: isFromMe == false
                              ? const Color(0xff74A3B7)
                              : null)))
        ]),
        YMargin(10.sp),
      ],
    ),
  );
}

bool isTextLengthy(
    double scale, String text, TextStyle textStyle, BuildContext context) {
  double screenWidth = 0.95.sw;

  TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: textStyle),
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width >= (screenWidth * scale);
}
