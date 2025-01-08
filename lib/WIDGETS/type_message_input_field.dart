// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/message_model/single_chat_model.dart';
import 'package:project_bist/core.dart';
import 'package:project_bist/main.dart';
import 'package:pdf/widgets.dart' as pw;

class TypeMessageInputField extends ConsumerStatefulWidget {
  TypeMessageInputField(
      {required this.messageInputController,
      this.hintText,
      this.onTap,
      this.autofocus,
      this.readOnly,
      this.suffixIcon,
      this.replyMessage,
      this.onCancelReply,
      this.suffixIconConstraints,
      this.isFromMe,
      this.onChanged,
      this.sendEnabled,
      this.onTapPickFile,
      this.onTapField,
      this.sentReplyMessage = "You",
      this.hasSuffix = true,
      super.key});
  String? hintText;
  void Function(String?)? onChanged;
  void Function()? onTapPickFile;
  bool? autofocus, hasSuffix, readOnly, sendEnabled, isFromMe;
  Widget? suffixIcon;
  Message? replyMessage;
  void Function()? onTapField, onCancelReply;
  BoxConstraints? suffixIconConstraints;
  void Function()? onTap;
  late TextEditingController messageInputController;
  String? sentReplyMessage;
  @override
  ConsumerState<TypeMessageInputField> createState() =>
      _TypeMessageInputFieldState();
}

class _TypeMessageInputFieldState extends ConsumerState<TypeMessageInputField> {
  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.sp, left: 15.sp, top: 10.sp),
      decoration: BoxDecoration(
          color: AppThemeNotifier.themeColor(context).scaffoldBackgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.replyMessage != null)
            Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 5.sp, top: 5.sp),
                        child: InkWell(
                            onTap: widget.onCancelReply,
                            child: const IconOf(Icons.cancel))),
                    replyBox(
                        replyMessage: widget.replyMessage,
                        sentReplyMessage: widget.sentReplyMessage),
                  ],
                )
              ],
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: InputField(
                    maxLines: incrementMaxLines(
                        textControllercontroller:
                            widget.messageInputController),
                    hintText: widget.hintText ?? "Type a message",
                    fillColor: AppColors.brown1(context),
                    //lineBreakLimiter: 6,
                    readOnly: widget.readOnly ?? false,
                    onTap: widget.onTapField,
                    inputType: TextInputType.multiline,
                    showCursor: (widget.readOnly ?? true),
                    autofocus: widget.autofocus ?? true,
                    suffixIconConstraints: widget.suffixIconConstraints,
                    hintColor: isDarkTheme(context)
                        ? AppColors.grey1
                        : AppColors.grey3,
                    onChanged: widget.onChanged,
                    //radius: 10.r,
                    boroderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.r),
                        topLeft: Radius.circular(10.r)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp)
                            .copyWith(bottom: 10.sp),
                    enabledBorderColor: AppColors.brown1(context),
                    focusedBorderColor: AppColors.brown1(context),
                    extra: -10,
                    suffixIcon: (widget.hasSuffix == true &&
                            ref.watch(switchUserProvider) !=
                                UserTypes.researcher)
                        ? InkWell(
                            onTap: widget.onTapPickFile,
                            child: ImageIcon(
                              AssetImage(ImageOf.fileAttachmnentIcon),
                              color: isDarkTheme(context)
                                  ? AppColors.grey1
                                  : AppColors.grey3,
                            ),
                          )
                        : widget.suffixIcon,
                    // suffixIcon: Image.asset(
                    //   ImageOf.fileAttachmnentIcon,
                    // ),
                    fieldController: widget.messageInputController),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: widget.sendEnabled == true ? widget.onTap : null,
                  child: CircleAvatar(
                    backgroundColor: widget.sendEnabled == true
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.5),
                    child: const IconOf(
                      Icons.send,
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


}

Container replyBox({Message? replyMessage, String? sentReplyMessage, Color? color}) {
    return Container(
      width: 0.825.sw,
      //height: 65.sp,
      margin: EdgeInsets.only(bottom: 5.sp),
      decoration: BoxDecoration(
          color: color?? AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r)),
      child: Center(
        child: Row(
          children: [
            Container(
                width: 5.sp,
                height: 65.sp,
                decoration: BoxDecoration(
                    color: Color.lerp(
                        AppColors.primaryColor, AppColors.white, 0.5),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        bottomLeft: Radius.circular(15.r)))),
            XMargin(2.5.sp),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.sp),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextOf(sentReplyMessage!, 15.sp, 5,
                        color: Color.lerp(
                            AppColors.primaryColor, AppColors.white, 0.5)),
                    YMargin(2.5.sp),
                    if (replyMessage!.attachmentName.isNotEmpty)
                      Row(
                        children: [
                          Image.asset(
                            ImageOf.chatAttachment,
                            height: 15.sp,
                          ),
                          XMargin(5.sp),
                          Flexible(
                              child: TextOf(
                                  "${replyMessage!.attachmentName}.", 15.sp, 1,
                                  align: TextAlign.left,
                                  textOverflow: TextOverflow.ellipsis)),
                          TextOf(replyMessage.attachmentType, 15.sp, 1,
                              align: TextAlign.left,
                              textOverflow: TextOverflow.ellipsis)
                        ],
                      ),
                    if (replyMessage.attachmentName.isNotEmpty) YMargin(2.5.sp),
                    if ((replyMessage.message ?? "").isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                              child: TextOf( firstNLines(replyMessage.message!, replyMessage.attachmentName.isNotEmpty), 13.sp, 1,
                                  align: TextAlign.left,
                                  textOverflow: TextOverflow.ellipsis))
                        ],
                      )
                  ]),
            ))
          ],
        ),
      ),
    );
  }

  String firstNLines(String fullText, bool containsAttachment) {
  List<String> lines = fullText.split('\n');
  String first3 = lines.take(containsAttachment?2:3).toList().join("\n");
  return first3;
}