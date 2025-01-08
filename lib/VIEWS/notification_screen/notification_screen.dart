// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/components/app_components.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import "package:timeago/timeago.dart" as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/notifications_provider/notifications_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/notification_model/notification_model.dart';
import 'package:project_bist/CORE/app_models.dart';

// ignore: must_be_immutable
class NotificationScreen extends ConsumerStatefulWidget {
  late TabController tabController;
  static const String notificationScreen = "notificationScreen";
  NotificationScreen({
    super.key,
    required this.tabController,
  });

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  bool hasDone = false;
  @override
  void initState() {
    if(ref.watch(switchUserProvider) == UserTypes.researcher){
      setState(() {
      widget.tabController = TabController(length: 4, vsync: this);
    });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatusOfAvailableNotifications =
        ref.watch(notificationsProvider);
    if (responseStatusOfAvailableNotifications.responseState ==
        ResponseState.LOADING) {
      ref.watch(notificationsProvider.notifier).getRequest(
          context: context,
          url: Endpoints.NOTIFICATION_GENERAL,
          showLoading: false);
    }

    /// ===============================[NOTIFICATION HANDLER]=====================
    /// ===============================[NOTIFICATION HANDLER]=====================
    List<dynamic>? rawNotificationsList =
        responseStatusOfAvailableNotifications.data;
    getIt<AppModel>().notificationsList = rawNotificationsList
        ?.map((e) => NotificationModel.fromJson(e))
        .toList();
    NotificationsList notificationsList =
        (getIt<AppModel>().notificationsList ?? []).reversed.toList();

    List<Widget> tabViewBodies = [
      notificationTabBView(context,
          notificationsList: notificationsList,
          emptyMessage:
              'All forms of your notifications will appear here when available'),
      notificationTabBView(context,
          notificationsList: notificationsList
              .where(
                (e) => e.type == "general",
              )
              .toList(),
          emptyMessage:
              "Miscellaneous notifications will appear here when available"),
      notificationTabBView(context,
          notificationsList:
              notificationsList.where((e) => e.type == "job").toList(),
          emptyMessage:
              "Notifications regarding your job updates will appear here when available"),
      notificationTabBView(context,
          notificationsList:
              notificationsList.where((e) => e.type == "payment").toList(),
          emptyMessage:
              "Notifications regarding payment for your jobs will appear here when available"),
    ];
    return DefaultTabController(
      length: ref.watch(switchUserProvider) != UserTypes.researcher ? 2 : 4,
      child: Scaffold(
          appBar: ref.watch(switchUserProvider) == UserTypes.researcher
              ? customAppBar(
                  context,
                  title: "Notification",
                  hasIcon: true,
                  tabBar: TabBar(
                    controller: widget.tabController,
                    physics: const ClampingScrollPhysics(),
                    labelColor: AppThemeNotifier.colorScheme(context).primary,
                    unselectedLabelColor:
                        AppThemeNotifier.colorScheme(context).primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.only(right: 20.sp),
                    indicatorPadding: EdgeInsets.only(right: 20.sp),
                    isScrollable: true,
                    labelStyle: TextStyle(
                        fontFamily: Fonts.nunito,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
                    padding: const EdgeInsets.all(0),
                    tabs: [
                      "All",
                      "General",
                      "Job Applications",
                      "Payment",
                    ]
                        .map(
                          (e) => Tab(
                            height: 30.sp,
                            text: e,
                          ),
                        )
                        .toList(),
                  ),
                )
              : null,
          body: switch (responseStatusOfAvailableNotifications.responseState!) {
            ResponseState.LOADING =>
              LoadingIndicator(message: "Fetching your notifications..."),
            ResponseState.ERROR => Expanded(
                child: ErrorPage(
                    message: responseStatusOfAvailableNotifications.message!,
                    onPressed: () {
                      ref.watch(notificationsProvider.notifier).getRequest(
                          context: context,
                          url: Endpoints.NOTIFICATION_GENERAL,
                          showLoading: false,
                          inErrorCase: true);
                    }),
              ),
            ResponseState.DATA => TabBarView(
                controller: widget.tabController,
                children: ref.watch(switchUserProvider) != UserTypes.researcher
                    ? [tabViewBodies[2], tabViewBodies[3]]
                    : tabViewBodies),
          }),
    );
  }

  Column notificationTabBView(BuildContext context,
      {required NotificationsList notificationsList,
      required String emptyMessage}) {
    return Column(
      children: [
        YMargin(10.sp),
        notificationsList.isEmpty
            ? Expanded(
                child: ErrorPage(message: emptyMessage, showButton: false))
            : Expanded(
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: appPadding(),
                    child: Column(
                        children: List.generate(
                            notificationsList.length,
                            (index) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextOf(notificationsList[index].title,
                                        13.sp, 7),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextOf(
                                            notificationsList[index].message,
                                            16.sp,
                                            4,
                                            align: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                    YMargin(7.5.sp),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextOf(
                                              timeago.format(
                                                  notificationsList[index]
                                                      .createdAt),
                                              12.sp,
                                              4,
                                              color: isDarkTheme(context)
                                                  ? AppColors.grey1
                                                  : const Color.fromRGBO(
                                                      107, 107, 107, 1)),
                                          InkWell(
                                            onTap: () {
                                              AppComponents
                                                  .confirmDeleteInListPopup(
                                                context,
                                                index,
                                                ref,
                                                popupTitle:
                                                    'Delete Notification',
                                                onPrimaryDeletePressed: () {
                                                  NotificationsProvider
                                                      .deleteNotification(
                                                          context, ref,
                                                          notificationId:
                                                              notificationsList[
                                                                      index]
                                                                  .id);
                                                },
                                                deletionButtonText:
                                                    "Delete This Notification",
                                                deletionDescriptionWidget:
                                                    RichText(
                                                        text: TextSpan(
                                                            text: "Clicking ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    Fonts
                                                                        .nunito,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppThemeNotifier
                                                                        .colorScheme(
                                                                            context)
                                                                    .primary),
                                                            children: [
                                                      TextSpan(
                                                          text:
                                                              '"Delete This Notification" ',
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  Fonts.nunito,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "will remove the selected notification from your list, while clicking ",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        Fonts
                                                                            .nunito,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppThemeNotifier.colorScheme(
                                                                            context)
                                                                        .primary),
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          '"Delete All Notifications" ',
                                                                      style: const TextStyle(
                                                                          fontFamily: Fonts
                                                                              .nunito,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                "will clear the entirety of the notifications you have available on this page. Both actions can't be undone. So please proceed with caution.",
                                                                            style: TextStyle(
                                                                                fontFamily: Fonts.nunito,
                                                                                fontSize: 16.sp,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: AppThemeNotifier.colorScheme(context).primary))
                                                                      ])
                                                                ])
                                                          ])
                                                    ])),
                                                bottomContent: Button2(
                                                  text:
                                                      "Delete All Notifications",
                                                  backgroundColor:
                                                      AppColors.red,
                                                  textColor: AppColors.white,
                                                  onPressed: () {
                                                    NotificationsProvider
                                                        .deleteAllNotifications(
                                                      context,
                                                      ref,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: const IconOf(
                                              Icons.more_vert_outlined,
                                            ),
                                          ),
                                        ]),
                                    YMargin(5.sp),
                                    index == (notificationsList.length - 1)
                                        ? const SizedBox.shrink()
                                        : AppDivider()
                                  ],
                                )))),
              ),
      ],
    );
  }

  // ElevatedButton deleteNotificationButton(
  //     {required String text,
  //     void Function()? onPressed,
  //     Color? backgroundColor,
  //     Color? textColor}) {
  //   return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: backgroundColor ?? AppColors.red,
  //           fixedSize: Size(
  //             0.85.sw,
  //             40.sp,
  //           ),
  //           shape: RoundedRectangleBorder(
  //               side: const BorderSide(color: AppColors.red),
  //               borderRadius: BorderRadius.circular(20.r))),
  //       onPressed: onPressed,
  //       child: TextOf(
  //         text,
  //         16.sp,
  //         5,
  //         color: textColor,
  //       ));
  // }
}
