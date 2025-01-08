import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/core.dart';

import '../MODELS/message_model/single_chat_model.dart';
import '../main.dart';

/// [sent_delivered_read]
class MessageItem extends ConsumerWidget {
  final SingleChatModel chatModel;

  const MessageItem({required this.chatModel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User friendProfile = [chatModel.user1, chatModel.user2]
        .where((e) => e.id != getIt<AppModel>().userProfile!.id)
        .first;

    return InkWell(
      onTap: () {
        // messageNotifier.getChats =
        Navigator.pushNamed(context, ChattingPage.chattingPage,
            arguments: ChattingPageArgument(
              user: friendProfile,
              picturePath: friendProfile.avatar,
              buddyName: friendProfile.fullName,
              recipientRole: friendProfile.role,
              userType: switch ((
                friendProfile.role,
                friendProfile.clientType
              )) {
                ("researcher", "") => UserTypes.researcher,
                ("client", "student") => UserTypes.student,
                ("client", "professional") => UserTypes.professional,
                _ => UserTypes.researcher
              },
              friendId: friendProfile.id,
              chatId: chatModel.id,
              messagesList: chatModel.messages,
            )).then((_) async {
          await ref.read(chatsProvider.notifier).connectSocket(context);
        });
      },
      child: Row(
        children: [
          CircleAvatar(
              radius: 30.sp,
              backgroundColor: AppColors.yellow3,
              child: buildProfileImage(
                  radius: 68.sp,
                  imageUrl: friendProfile.avatar,
                  fullNameTobSplit: friendProfile.fullName,
                  fontWeight: 5)),
          XMargin(10.sp),
          Expanded(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextOf(
                      friendProfile.fullName,
                      16.sp,
                      5,
                      align: TextAlign.left,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: TextOf(
                        chatModel.messages.isEmpty
                            ? ""
                            : AppMethods.handleMessageComeInDate(chatModel
                                .messages.last.createdAt
                                .add(const Duration(hours: 1))),
                        12,
                        4,
                        color: AppThemeNotifier.colorScheme(context).primary,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 9,
                      child: Row(
                    children: [
                      switch (chatModel.messages.isEmpty) {
                        true => TextOf(
                            "Start a conversation",
                            14.sp,
                            4,
                            textOverflow: TextOverflow.ellipsis,
                            align: TextAlign.left,
                            fontStyle: chatModel.messages.isEmpty
                                ? FontStyle.italic
                                : null,
                          ),
                        _ => switch (chatModel.messages.last.sender ==
                              getIt<AppModel>().userProfile!.id) {
                            true => TextOf(
                                "You:",
                                14.sp,
                                4,
                                textOverflow: TextOverflow.ellipsis,
                                align: TextAlign.left,
                                fontStyle: chatModel.messages.isEmpty
                                    ? FontStyle.italic
                                    : null,
                              ),
                            _ => const SizedBox.shrink()
                          }
                      },
                      switch (chatModel.messages.last.attachment.isNotEmpty) {
                        true => Row(
                            children: [
                              XMargin(5.sp),
                              IconOf(Icons.description_outlined, size: 15.sp),
                            ],
                          ),
                        _ => const SizedBox.shrink()
                      },
                      Expanded(
                        child: TextOf(
                          (getCharacters((chatModel.messages.last.message??"")).isEmpty)
                              ? " ${chatModel.messages.last.attachmentName}.${chatModel.messages.last.attachmentType}"
                              : " ${getCharacters(chatModel.messages.last.message!)}",
                          14.sp,
                          4,
                          textOverflow: TextOverflow.ellipsis,
                          align: TextAlign.left,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          chatModel.messages
                                  .map((e) => e.status != "read")
                                  .isEmpty
                              ? const SizedBox.shrink()
                              : (chatModel.messages
                                          .map((e) => e.status != "read")
                                          .length
                                          .toString()
                                          .length >=
                                      2
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.5.sp, horizontal: 9.sp),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(200.r),
                                          color: AppColors.primaryColor),
                                      child: TextOf(
                                        chatModel.messages
                                            .map((e) => e.status != "read")
                                            .length
                                            .toString(),
                                        10.sp,
                                        4,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 13.sp,
                                      backgroundColor: AppColors.primaryColor,
                                      child: TextOf(
                                        chatModel.messages
                                            .map((e) => e.status != "read")
                                            .length
                                            .toString(),
                                        10.sp,
                                        4,
                                        color: AppColors.white,
                                      ),
                                    ))
                        ],
                      ))
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}

String getCharacters(String text) {
  String processedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  return processedText.length > text.length
      ? processedText.substring(0, text.length)
      : processedText;
}
