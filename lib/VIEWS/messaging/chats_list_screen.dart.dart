// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/message_provider/chats_provider.dart';
import 'package:project_bist/PROVIDERS/message_provider/message_state.dart';
import 'package:project_bist/WIDGETS/error_page.dart' as err;
import 'package:project_bist/core.dart';
import 'package:project_bist/main.dart';

import '../../MODELS/message_model/single_chat_model.dart';

final chatsProvider = StateNotifierProvider<MessageNotifier, ChatStatus>((ref) => MessageNotifier());

class AvailableChatsList extends ConsumerStatefulWidget {
  AvailableChatsList({
    super.key,
    this.isHamburger = false,
  });
  bool? isHamburger;
  static const String availableChatsList = "availableChatsList";

  @override
  _AvailableChatsListState createState() => _AvailableChatsListState();
}

class _AvailableChatsListState extends ConsumerState<AvailableChatsList> {
  @override
  void initState() {
    ref.read(chatsProvider.notifier).connectSocket(context);
    AppMethods. loadProjectBistFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          drawer: const DrawerContents(),
          appBar: ref.watch(switchUserProvider) == UserTypes.researcher
              ? customAppBar(
                  context,
                  title: "Messages",
                  scale: 1.25.sp,
                  actions: (ref.watch(chatsProvider).data??[]).isEmpty
                      ? null
                      : [
                          Padding(
                            padding: EdgeInsets.only(right: 20.sp),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    SearchvailableChatsPage
                                        .searchvailableChatsPage);
                              },
                              child: Image.asset(
                                ImageOf.searchIcon,
                                height: 20.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        ],
                  tabBar: TabBar(
                      physics: const ClampingScrollPhysics(),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.all(0),
                      indicatorPadding: const EdgeInsets.all(0),
                      labelColor: AppThemeNotifier.colorScheme(context).primary,
                      unselectedLabelColor:
                          AppThemeNotifier.colorScheme(context).primary,
                      padding: const EdgeInsets.all(0),
                      tabs: ["Students", "Professionals", "Researchers"]
                          .map((e) => Tab(
                                height: 30.sp,
                                text: e,
                              ))
                          .toList()),
                  hasElevation: true,
                  leading: Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        widget.isHamburger != true
                            ? Scaffold.of(context).openDrawer()
                            : Navigator.pop(context);
                      },
                      child: IconOf(
                          widget.isHamburger != true
                              ? Icons.menu
                              : Icons.arrow_back_ios_rounded,
                          color: AppColors.primaryColor),
                    );
                  }),
                  hasIcon: true,
                )
              : null,
          body: switch (ref.watch(chatsProvider).chatState) {
            ChatState.ERROR => err.ErrorPage(
              message: ref.watch(chatsProvider).message??"Unknown error occured!\nExit this page and revisit",
                showButton: false,
              ),
            ChatState.LOADING => LoadingIndicator(message: "Loading your messages..."),
            _=> switch((ref.watch(chatsProvider).data??[]).isEmpty){
              true => err.ErrorPage(
              message: "You've not started any conversation yet.\nYour chats will appear here when you have",
                showButton: false,
              ),
              _=> switch (
                  ref.watch(switchUserProvider) != UserTypes.researcher) {
                true => SafeArea(
                      child: ListView.separated(
                    padding: appPadding(),
                    itemBuilder: (context, index) {
                      SingleChatModel chatModel =
                          (ref.watch(chatsProvider).data??[])[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onLongPress: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Container(
                                  color: AppColors.white,
                                  padding: EdgeInsets.all(10.sp),
                                  width: double.infinity,
                                  child: InkWell(
                                      child: TextOf("Delete", 20.sp, 6,
                                          color: AppColors.red),
                                      onTap: () {
                                        ref
                                            .read(chatsProvider.notifier)
                                            .deleteChat(context, chatModel.id);
                                      })));
                        },
                        child: MessageItem(
                          chatModel: chatModel,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => AppDivider(),
                    itemCount: (ref.watch(chatsProvider).data??[]).length,
                  )),
                false => SafeArea(
                    child: TabBarView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          /// [STUDENTS_CHATS_LIST]
                          Builder(builder: (context) {
                            List<SingleChatModel> studentsList = [
                              for (SingleChatModel chat
                                  in (ref.watch(chatsProvider).data??[]))
                                for (User user in [chat.user1, chat.user2])
                                  if (user.id !=
                                      getIt<AppModel>().userProfile!.id)
                                    if (user.clientType == "student") chat
                              //if([chat.user1 , chat.user2].where((e)=> e.id != getIt<AppModel>().userProfile!.id).first.clientType == "student")
                            ];
                            return studentsList.isEmpty
                                ? err.ErrorPage(
                                    message:
                                        "Your chats with students will appear here when available",
                                    showButton: false)
                                : ListView.separated(
                                    padding: appPadding(),
                                    itemBuilder: (context, index) {
                                      SingleChatModel chatModel =
                                          studentsList[index];
                                      return MessageItem(
                                        chatModel: chatModel,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        AppDivider(),
                                    itemCount: studentsList.length,
                                  );
                          }),

                          /// PROFESSIONAL_CHATS_LIST
                          Builder(builder: (context) {
                            List<SingleChatModel> professionalsList = [
                              for (SingleChatModel chat
                                  in (ref.watch(chatsProvider).data??[]))
                                for (User user in [chat.user1, chat.user2])
                                  if (user.id !=
                                      getIt<AppModel>().userProfile!.id)
                                    if (user.clientType == "professional") chat
                            ];
                            // List<SingleChatModel> professionalsList =   ref.watch(chatsProvider).where((e){
                            //   User user = [e.user1 , e.user2].where((e)=> e.id != getIt<AppModel>().userProfile!.id).first;
                            //   //bool isProfessional = user.clientType == "professional";
                            //   return (true);
                            // }).toList();
                            return professionalsList.isEmpty
                                ? err.ErrorPage(
                                    message:
                                        "Your chats with professionals will appear here when available",
                                    showButton: false)
                                : ListView.separated(
                                    padding: appPadding(),
                                    itemBuilder: (context, index) {
                                      SingleChatModel chatModel =
                                          professionalsList[index];
                                      return MessageItem(
                                        chatModel: chatModel,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        AppDivider(),
                                    itemCount: professionalsList.length,
                                  );
                          }),

                          /// RESEARCHERS_CHATS_LIST
                          Builder(builder: (context) {
                            List<SingleChatModel> researchersList = [
                              for (SingleChatModel chat
                                  in (ref.watch(chatsProvider).data??[]))
                                for (User user in [chat.user1, chat.user2])
                                  if (user.id !=
                                      getIt<AppModel>().userProfile!.id)
                                    if (user.clientType == "") chat
                            ];
                            // ref.watch(chatsProvider).where((e){
                            //   User user = [e.user1 , e.user2].where((e)=> e.id != getIt<AppModel>().userProfile!.id).first;
                            //   //bool isResearcher = user.clientType == null;
                            //   return (true);
                            // }).toList();
                            return researchersList.isEmpty
                                ? err.ErrorPage(
                                    message:
                                        "Your chats with researchers will appear here when available",
                                    showButton: false)
                                : ListView.separated(
                                    padding: appPadding(),
                                    itemBuilder: (context, index) {
                                      SingleChatModel chatModel =
                                          researchersList[index];
                                      return MessageItem(
                                        chatModel: chatModel,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        AppDivider(),
                                    itemCount: researchersList.length,
                                  );
                          }),
                        ]),
                  ),
              }
            }
          }),
    );
  }
}
