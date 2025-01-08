import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/message_item.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/VIEWS/messaging/chats_list_screen.dart.dart';
import '../../MODELS/message_model/single_chat_model.dart';

class SearchvailableChatsPage extends ConsumerStatefulWidget {
  static const String searchvailableChatsPage = "searchvailableChatsPage";
  const SearchvailableChatsPage({super.key});
  @override
  ConsumerState<SearchvailableChatsPage> createState() =>
      _SearchvailableChatsPageState();
}

class _SearchvailableChatsPageState
    extends ConsumerState<SearchvailableChatsPage> {
  late TextEditingController searchFieldController;
  @override
  void initState() {
    searchFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: appPadding().copyWith(bottom: 0),
              child: InputField(
                  hintText: "Search for your chats...",
                  fillColor: AppColors.brown1(context),
                  autofocus: true,
                  onChanged: (_) {
                    setState(() {});
                  },
                  radius: 10.r,
                  hintColor: AppThemeNotifier.colorScheme(context).primary ==
                          AppColors.white
                      ? AppColors.grey1
                      : AppColors.grey3,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                  enabledBorderColor: AppColors.brown1(context),
                  focusedBorderColor: AppColors.brown1(context),
                  prefixIcon: IconOf(
                    Icons.search,
                    size: 23.sp,
                    color: AppThemeNotifier.colorScheme(context).primary ==
                            AppColors.white
                        ? AppColors.grey1
                        : AppColors.grey3,
                  ),
                  suffixIcon: searchFieldController.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            searchFieldController.clear();
                            setState(() {});
                          },
                          child: const IconOf(Icons.close))
                      : const SizedBox.shrink(),
                  fieldController: searchFieldController),
            ),
            YMargin(10.sp),
            switch(ref.watch(chatsProvider.notifier).searchChatList(searchQuery: searchFieldController.text).isEmpty){
              true => Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      YMargin(0.2.sh),
                      ErrorPage(message: "No matching result for your inputs", showButton: false),
                      YMargin(0.05.sh),
                    ],
                  ),
                ),
              ),
              _=>   Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                    ref
                        .watch(chatsProvider.notifier)
                        .searchChatList(searchQuery: searchFieldController.text)
                        .length, (index) {
                  SingleChatModel chatModel = ref
                      .watch(chatsProvider.notifier)
                      .searchChatList(
                          searchQuery: searchFieldController.text)[index];
                  return Padding(
                    padding: appPadding().copyWith(top: 0, bottom: 10.sp),
                    child: MessageItem(
                      chatModel: chatModel,
                    ),
                  );
                }),
              ),
            ))
            }
          ],
        ),
      ),
    );
  }
}
