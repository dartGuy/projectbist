// ignore_for_file: must_be_immutable
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/all_nav_screens/home_pages/client_home_page.dart';
import "package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart";
import 'package:project_bist/VIEWS/messaging/search_available_chat.dart';
import 'package:project_bist/VIEWS/notification_screen/notification_screen.dart';
import 'package:project_bist/VIEWS/researcher_publish_paper_page/researcher_publish_paper_page.dart';
import "package:project_bist/main.dart";
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/VIEWS/messaging/chats_list_screen.dart.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/VIEWS/all_nav_screens/home_pages/researcher_home_screens.dart';


// jcj
class AllNavScreens extends ConsumerStatefulWidget {
  static const allNavScreens = "allNavScreens";
  int? currentIndex;
  AllNavScreens({this.currentIndex = 0, super.key});

  @override
  ConsumerState<AllNavScreens> createState() => _AllNavScreensState();
}

class _AllNavScreensState extends ConsumerState<AllNavScreens>
    with SingleTickerProviderStateMixin {
  late TabController notificationTabController;
  int selectedIndex = 0;

  bool canPop = false;
  @override
  void initState() {
    ref.read(chatsProvider.notifier).connectSocket(context);
    //ref.read(messageProvider.notifier).connectSocket(context);
    setState(() {
      selectedIndex = widget.currentIndex ?? 0;
      notificationTabController = TabController(length: 2, vsync: this);
    });
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      // AppMethods.invalidateProviders(ref: ref);
      ref.watch(switchUserProvider.notifier).switchUser(
              (switch (getIt<AppModel>().appCacheBox!.get(AppConst.USER_TYPE)) {
            "researcher" => UserTypes.researcher,
            "professional" => UserTypes.professional,
            "student" => UserTypes.student,
            _ => UserTypes.researcher
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<NavBarItem> bottomNavItems = [
      NavBarItem(
        index: 0,
        icon: Image.asset(
          selectedIndex == 0 ? ImageOf.onNavHome : ImageOf.homeNav,
          height: 24.sp,
        ),
        label: "Home",
      ),
      NavBarItem(
        index: ref.watch(switchUserProvider) == UserTypes.researcher ? 1 : 2,
        icon: Image.asset(
          (widget.currentIndex == 1 &&
                  ref.watch(switchUserProvider) == UserTypes.researcher)
              ? ImageOf.onNavMessage
              : (widget.currentIndex == 2 &&
                      ref.watch(switchUserProvider) != UserTypes.researcher)
                  ? ImageOf.onNavNotification
                  : (ref.watch(switchUserProvider) == UserTypes.researcher
                      ? ImageOf.messageNav
                      : ImageOf.notificationNav),
          height: 24.sp,
        ),
        label: ref.watch(switchUserProvider) == UserTypes.researcher
            ? "Message"
            : "Notification",
      )
    ];

    List<Widget> navPageBody = [
      ref.watch(switchUserProvider) == UserTypes.researcher
          ? ResearcherHomeScreen(callback: (){
            Future.delayed(const Duration(milliseconds: 750), (){setState(() {
          });});
            })
          : ClientHomePage(callback: (){
            Future.delayed(const Duration(milliseconds: 750), (){setState(() {
          });});
            }),
      ref.watch(switchUserProvider) == UserTypes.researcher
          ? AvailableChatsList(
              isHamburger: true,
            )
          : NotificationScreen(tabController: notificationTabController)
    ];
    ref.watch(switchUserProvider) != UserTypes.researcher
        ? bottomNavItems.insert(
            1,
            NavBarItem(
              index: 1,
              icon: Image.asset(
                selectedIndex == 1 ? ImageOf.onNavMessage : ImageOf.messageNav,
                height: 24.sp,
              ),
              label: "Messages",
            ),
          )
        : () {};
    ref.watch(switchUserProvider) != UserTypes.researcher
        ? navPageBody.insert(1, AvailableChatsList(isHamburger: false))
        : () {};

    return Scaffold(
      appBar: (ref.watch(switchUserProvider) == UserTypes.researcher &&
              selectedIndex == 1)
          ? null
          : customAppBar(context,
              hasElevation:
                  (ref.watch(switchUserProvider) != UserTypes.researcher ||
                          ((ref.watch(switchUserProvider) == UserTypes.researcher &&
                                  selectedIndex == 1) ||
                              selectedIndex == 2))
                      ? true
                      : false,
              title: ((ref.watch(switchUserProvider) == UserTypes.researcher &&
                          selectedIndex == 1) ||
                      selectedIndex == 2)
                  ? "Notification"
                  : (ref.watch(switchUserProvider) != UserTypes.researcher &&
                          selectedIndex == 1)
                      ? "Messages"
                      : "Home", leading: (AppConst.HOME_PAGE_LOADED == false && AppConst.APP_ROUTE==AllNavScreens.allNavScreens)? const SizedBox.shrink(): Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const IconOf(Icons.menu, color: AppColors.primaryColor),
              );
            }),
              tabBar: ((ref.watch(switchUserProvider) == UserTypes.researcher &&
                          selectedIndex == 1) ||
                      selectedIndex == 2)
                  ? TabBar(
                      controller: notificationTabController,
                      physics: const ClampingScrollPhysics(),
                      labelColor: AppThemeNotifier.colorScheme(context).primary,
                      unselectedLabelColor:
                          AppThemeNotifier.colorScheme(context).primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.all(0),
                      indicatorPadding: const EdgeInsets.all(0),
                      labelStyle: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.all(0),
                      tabs: [
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
                    )
                  : null,
              hasIcon: true,
              actions: (ref.watch(switchUserProvider) == UserTypes.researcher &&
                      selectedIndex == 0)
                  ? [
                      Padding(
                        padding: EdgeInsets.only(right: 20.sp),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NotificationScreen.notificationScreen,
                              arguments: notificationTabController,
                            );
                            // Navigator.pushNamed(
                            //     context, AvailableChatsList.availableChatsList,
                            //     arguments: UserTypes.researcher);
                          },
                          child: Image.asset(ImageOf.onNavNotification,
                              height: 24.sp),
                        ),
                      )
                    ]
                  : (ref.watch(switchUserProvider) != UserTypes.researcher && selectedIndex == 1)
                      ? [
                          Padding(
                            padding: EdgeInsets.only(right: 20.sp),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  SearchvailableChatsPage
                                      .searchvailableChatsPage,
                                );
                              },
                              child: Image.asset(
                                ImageOf.searchIcon,
                                height: 20.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        ]
                      : [],
              scale: 1.25.sp),
      drawer: const DrawerContents(),
      body: PopScope(
        canPop: false,
        onPopInvoked: ((pop) {
          if (pop) {
            return;
          }
          onWillPop();
        }),
        // onWillPop: () async {
        //   return await onWillPop();
        // },
        child: navPageBody.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 104.sp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                YMargin(15.sp),
                Container(
                  height: 74.sp,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppThemeNotifier.themeColor(context)
                          .scaffoldBackgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      YMargin(5.sp),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: bottomNavItems
                              .map((e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = e.index;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        YMargin(4.sp),
                                        e.icon,
                                        YMargin(4.sp),
                                        TextOf(
                                          e.label,
                                          10,
                                          4,
                                          color: e.index == selectedIndex
                                              ? AppColors.primaryColor
                                              : (AppThemeNotifier.colorScheme(
                                                      context)
                                                  .onSecondary),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ref.watch(switchUserProvider) == UserTypes.researcher
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                        height: 90.sp,
                        width: 90.sp,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                ResearchPublishPaperScreen
                                    .researchPublishPaperScreen);
                          },
                          child: Transform.scale(
                              scale: 0.8.sp,
                              child: SvgPicture.asset(
                                  ImageOf.floatingActionButton)),
                        )),
                    Positioned(
                      bottom: -2.sp,
                      child: TextOf("Publish a Paper", 10, 4),
                    )
                  ],
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  void onWillPop() async {
    Alerts.optionalDialog(
      context,
      title: "Quitting ProjectBist",
      text: "Are you sure you want to quit?",
      left: "Yes",
      right: "No",
      onTapLeft: () {
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
      },
      onTapRight: () {
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(false);
      },
    );
  }
}

class NavBarItem {
  final Widget icon;
  final int index;
  final String label;

  NavBarItem({required this.index, required this.icon, required this.label});
}
