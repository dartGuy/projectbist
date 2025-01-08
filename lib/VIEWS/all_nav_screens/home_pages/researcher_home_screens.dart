// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/job_model/reseracher_job_model.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/components/app_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/job_item.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/profile_item.dart';
import 'package:project_bist/WIDGETS/publication_item.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class ResearcherHomeScreen extends ConsumerStatefulWidget {
  VoidCallback callback;
ResearcherHomeScreen({required this.callback, super.key});

  static const String researcherHomeScreen = "researcherHomeScreen";

  @override
  _ResearcherHomeScreenState createState() => _ResearcherHomeScreenState();
}

class _ResearcherHomeScreenState extends ConsumerState<ResearcherHomeScreen> {
  int currentIndex = 0;
  bool hasDone = false;
  bool isJobFitered = false,
      isJPublicationsFiltered = false,
      isProfileFitered = false;

  bool isTrue = true;
  // You can declare variables and functions here
  late TextEditingController searchFieldController;

  @override
  void initState() {
    setState(() {
      searchFieldController = TextEditingController();
    });
    super.initState();
  }

  denoteFilteredWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (currentIndex == 1) {
              setState(() {
                isJobFitered = false;
              });
            } else if (currentIndex == 2) {
              setState(() {
                isJPublicationsFiltered = false;
              });
            } else if (currentIndex == 3) {
              setState(() {
                isProfileFitered = false;
              });
            }
          },
          child: IconOf(
            Icons.close,
            size: 20.sp,
            color: AppColors.black,
          ),
        ),
        XMargin(10.sp),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColors.brown),
            height: 29.sp,
            width: 73.sp,
            child: Center(
                child: TextOf(
              "Filtered",
              12,
              4,
              color: AppColors.white,
            ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    ResponseStatus responseStatusOfPublication =
            ref.watch(generalPublicationsProvider),
        responseStatusOfProfile = ref.watch(profileProvider),
        responseMyJobsList = ref.watch(researcherJobsProvider),
        responseStatusOfResearchersProfile =
            ref.watch(researchersProfileProvider),
        responseStatusOfWalletTransactions = ref.watch(transactionProvider);
    ref.read(escrowsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ESCROWS("researcher"),
        showLoading: false);
    ref.watch(generalPublicationsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.GENERAL_PUBLICATIONS_LIST,
        showLoading: false);

    ref.watch(profileProvider.notifier).getRequest(
        context: context, url: Endpoints.GET_PROFILE, showLoading: false);
    getIt<AppModel>().userProfile =
        UserProfile.fromJson(responseStatusOfProfile.data);

    ref.watch(researcherJobsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.RESEARCHER_FETCH_ALL_JOBS,
        showLoading: false);

    ref.watch(researchersProfileProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ALL_RESEARCHER_PROFILES,
        showLoading: false);

    if (getIt<AppModel>().userProfile!.identityVerified == true) {

      ref.read(transactionProvider.notifier).getRequest(
          context: context, url: Endpoints.FETCH_WALLET, showLoading: false);

      print(responseStatusOfWalletTransactions.data);
    }

    getIt<AppModel>().appCacheBox!.put(AppConst.USER_WALLET_BALANCE,
        responseStatusOfWalletTransactions.data?["amount"]);
    getIt<AppModel>().appCacheBox!.put(AppConst.USER_ESCROW_BALANCE,
        responseStatusOfWalletTransactions.data?["escrowAmount"]);

    /// ===============================[PUBLICATION HANDLER]=====================
    /// ===============================[PUBLICATION HANDLER]=====================
    List<dynamic>? publicationsList = responseStatusOfPublication.data;
    getIt<AppModel>().generalPublicationList =
        publicationsList?.map((e) => PublicationModel.fromJson(e)).toList();
    PublicationsList generalPublicationList =
        getIt<AppModel>().generalPublicationList ?? [];

    /// ===============================[PROFILE HANDLER]=====================
    /// ===============================[PROFILE HANDLER]=====================
    getIt<AppModel>().appCacheBox!.put(AppConst.BACKEND_VERIFIED_USER,
        getIt<AppModel>().userProfile?.identityVerified ?? false);
    //UserProfile userProfile = getIt<AppModel>().userProfile!;
    List? rawResearchersProfiles = responseStatusOfResearchersProfile.data;
    getIt<AppModel>().researcherProfilesList =
        rawResearchersProfiles?.map((e) => UserProfile.fromJson(e)).toList();

    /// ===============================[JOB HANDLER]=====================
    /// ===============================[JOB HANDLER]=====================
    List<dynamic>? rawResearcherJobList = responseMyJobsList.data;
    getIt<AppModel>().researcherJobList = rawResearcherJobList
        ?.map((e) => ResearcherJobModel.fromJson(e))
        .toList();
    ResearcherJobList researcherJobList =
        getIt<AppModel>().researcherJobList ?? [];

    /// ===============================[ESCROW HANDLER]=====================
    /// ===============================[ESCROW HANDLER]=====================
    ResponseStatus responseStatusOfEscrow = ref.watch(escrowsProvider);
    List<dynamic>? rawEscrowsList = responseStatusOfEscrow.data;
    getIt<AppModel>().escrowWithSubmissionPlanList = rawEscrowsList
        ?.map((e) => EscrowWithSubmissionPlanModel.fromJson(e))
        .toList()
        .where((e) => e.jobId != null)
        .toList();

    /// ============================== [SCAFFOLD COLOR] ========================
    /// ============================== [SCAFFOLD COLOR] ========================
    var thisWhite =
        AppThemeNotifier.themeColor(context).scaffoldBackgroundColor;

    List<Widget> tabBodies = [
      SeeAllTab(
        generalPublicationList: generalPublicationList,
        userProfileList: getIt<AppModel>().researcherProfilesList ?? [],
        researcherJobList: researcherJobList,
      ),
      generalPublicationList.isEmpty
          ? ErrorPage(
              message: "No job available at the moment!", showButton: false)
          : Column(
              children: List.generate(researcherJobList.length, (index) {
              return Padding(
                  padding: EdgeInsets.only(bottom: 16.sp),
                  child: JobItem(
                      researcherJobModel: researcherJobList[index],
                      width: double.infinity));
            })),
      generalPublicationList.isEmpty
          ? ErrorPage(
              message: "Publications are currently not available!",
              showButton: false)
          : Column(
              children: List.generate(generalPublicationList.length, (index) {
              PublicationModel publicationModel = generalPublicationList[index];
              return Padding(
                  padding: EdgeInsets.only(bottom: 16.sp),
                  child: PublicationItem(
                    width: double.infinity,
                    publicationList: generalPublicationList,
                    publicationModel: publicationModel,
                  ));
            })),
      (getIt<AppModel>().researcherProfilesList ?? []).isEmpty
          ? ErrorPage(
              message: "People are currently not available!", showButton: false)
          : SizedBox(
              height: 0.8.sh,
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.7,
                mainAxisSpacing: 10.sp,
                crossAxisSpacing: 10.sp,
                children: List.generate(
                    (getIt<AppModel>().researcherProfilesList ?? []).length,
                    (index) {
                  return ProfileItem(
                    userProfile:
                        (getIt<AppModel>().researcherProfilesList ?? [])[index],
                  );
                }),
              ))
    ];

    String errorMessage = "";

    if (responseStatusOfPublication.message != null) {
      errorMessage +=
          "Publications Error: ${responseStatusOfPublication.message}\n";
    }

    if (responseStatusOfEscrow.message != null) {
      errorMessage += "Escrow Error: ${responseStatusOfEscrow.message}\n";
    }

    if (responseStatusOfProfile.message != null) {
      errorMessage += "Profile Error: ${responseStatusOfProfile.message}\n";
    }

    if (responseMyJobsList.message != null) {
      errorMessage += "Jobs Error: ${responseMyJobsList.message}\n";
    }

    if (responseStatusOfResearchersProfile.message != null) {
      errorMessage +=
          "Profiles Error: ${responseStatusOfResearchersProfile.message}\n";
    }

    if (responseStatusOfWalletTransactions.message != null) {
      errorMessage +=
          "Wallet Error: ${responseStatusOfWalletTransactions.message}\n";
    }

if(responseStatusOfEscrow .responseState== ResponseState.DATA && responseStatusOfPublication .responseState== ResponseState.DATA && responseStatusOfProfile .responseState== ResponseState.DATA && responseMyJobsList .responseState== ResponseState.DATA && responseStatusOfResearchersProfile .responseState== ResponseState.DATA && responseStatusOfWalletTransactions.responseState== ResponseState.DATA){
AppConst.HOME_PAGE_LOADED = true;
widget.callback();
} else{
  AppConst.HOME_PAGE_LOADED = false;
}


    return Scaffold(
      body: (responseStatusOfPublication.responseState! ==
                  ResponseState.LOADING ||
              responseStatusOfProfile.responseState! == ResponseState.LOADING ||
              responseMyJobsList.responseState! == ResponseState.LOADING ||
              (getIt<AppModel>().userProfile!.identityVerified == true
                  ? responseStatusOfWalletTransactions.responseState ==
                      ResponseState.LOADING
                  : isTrue == false) ||
              responseStatusOfResearchersProfile.responseState! ==
                  ResponseState.LOADING ||
              responseStatusOfEscrow.responseState! == ResponseState.LOADING)
          ? LoadingIndicator(message: "Please wait a moment...")
          : (responseStatusOfPublication.responseState! ==
                      ResponseState.ERROR ||
                  responseStatusOfProfile.responseState! ==
                      ResponseState.ERROR ||
                  (getIt<AppModel>().userProfile!.identityVerified == true
                      ? responseStatusOfWalletTransactions.responseState ==
                          ResponseState.ERROR
                      : isTrue == false) ||
                  responseStatusOfEscrow.responseState! ==
                      ResponseState.ERROR ||
                  responseMyJobsList.responseState == ResponseState.ERROR)
              ? ErrorPage(
                  message: errorMessage,
                  onPressed: () {
                    if (ref.watch(generalPublicationsProvider).responseState ==
                        ResponseState.ERROR) {
                      ref
                          .watch(generalPublicationsProvider.notifier)
                          .getRequest(
                              context: context,
                              url: Endpoints.GENERAL_PUBLICATIONS_LIST,
                              showLoading: false,
                              inErrorCase: true);
                    }
                    if (ref.watch(profileProvider).responseState ==
                        ResponseState.ERROR) {
                      ref.watch(profileProvider.notifier).getRequest(
                          context: context,
                          url: Endpoints.GET_PROFILE,
                          showLoading: false,
                          inErrorCase: true);
                    }

                    if (ref.watch(researcherJobsProvider).responseState ==
                        ResponseState.ERROR) {
                      ref.watch(researcherJobsProvider.notifier).getRequest(
                          context: context,
                          url: Endpoints.RESEARCHER_FETCH_ALL_JOBS,
                          showLoading: false,
                          inErrorCase: true);
                    }

                    if (ref.watch(researchersProfileProvider).responseState ==
                        ResponseState.ERROR) {
                      ref.watch(researchersProfileProvider.notifier).getRequest(
                          context: context,
                          url: Endpoints.RESEARCHER_FETCH_ALL_JOBS,
                          showLoading: false,
                          inErrorCase: true);
                    }

                    if(ref.read(escrowsProvider).responseState ==
                      ResponseState.ERROR){
ref.read(escrowsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ESCROWS("researcher"),
        showLoading: false,
                        inErrorCase: true);
                      }
                      if(ref.read(escrowsProvider).responseState ==
                      ResponseState.ERROR){
ref.read(escrowsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ESCROWS("researcher"),
        showLoading: false,
                        inErrorCase: true);
                      }
                       if(ref.read(transactionProvider).responseState ==
                      ResponseState.ERROR){
 ref.read(transactionProvider.notifier).getRequest(
          context: context, url: Endpoints.FETCH_WALLET, showLoading: false);
                      }


                  })
              : Column(
                  children: [
                    Container(
                      padding: appPadding(),
                      decoration: BoxDecoration(
                          color: thisWhite,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: -5,
                              color: AppColors.grey1,
                              offset: Offset(0, 5),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Container(
                            decoration: AppThemeNotifier.colorScheme(context)
                                        .primary ==
                                    AppColors.black
                                ? BoxDecoration(boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppColors.grey1.withOpacity(0.7),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: const Offset(0.5, 0.75))
                                  ])
                                : null,
                            child: InputField(
                                hintText: "Search for anything...",
                                fillColor: AppColors.brown1(context),
                                radius: 10.r,
                                hintColor: AppThemeNotifier.colorScheme(context)
                                            .primary ==
                                        AppColors.white
                                    ? AppColors.grey1
                                    : AppColors.grey3,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10.sp),
                                enabledBorderColor: AppColors.brown1(context),
                                focusedBorderColor: AppColors.brown1(context),
                                prefixIcon: IconOf(
                                  Icons.search,
                                  size: 23.sp,
                                  color: AppThemeNotifier.colorScheme(context)
                                              .primary ==
                                          AppColors.white
                                      ? AppColors.grey1
                                      : AppColors.grey3,
                                ),
                                fieldController: searchFieldController),
                          ),
                          YMargin(16.sp),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                                4,
                                (index) => InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                      });
                                    },
                                    child: Container(
                                      height: 31.sp,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.sp),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: currentIndex == index
                                                  ? AppColors.primaryColor
                                                  : AppColors.grey1),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          color: currentIndex == index
                                              ? AppColors.primaryColor
                                              : thisWhite),
                                      child: Center(
                                        child: TextOf(
                                          index == 0
                                              ? "See all"
                                              : index == 1
                                                  ? "Jobs"
                                                  : index == 2
                                                      ? "Publications"
                                                      : "People",
                                          12.sp,
                                          4,
                                          color: currentIndex == index
                                              ? AppColors.white
                                              : (AppThemeNotifier.colorScheme(
                                                              context)
                                                          .primary ==
                                                      AppColors.white
                                                  ? AppColors.grey1
                                                  : AppColors.grey3),
                                        ),
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: appPadding().add(EdgeInsets.symmetric(
                          horizontal: currentIndex == 0 ? -5.sp : 0)),
                      child: Column(
                        children: [
                          ((isJobFitered == true && currentIndex == 1) ||
                                  (isJPublicationsFiltered == true &&
                                      currentIndex == 2) ||
                                  (isProfileFitered == true &&
                                      currentIndex == 3))
                              ? denoteFilteredWidget()
                              : currentIndex == 0
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        generalPublicationList.isEmpty &&
                                                currentIndex == 2
                                            ? const SizedBox.shrink()
                                            : InkWell(
                                                onTap: () {
                                                  if (currentIndex == 1) {
                                                    AppBottomSheet.filterJob(
                                                        context,
                                                        onTapFilter: () {
                                                      setState(() {
                                                        isJobFitered = true;
                                                      });
                                                    });
                                                  } else if (currentIndex ==
                                                      2) {
                                                    AppBottomSheet
                                                        .filterPublication(
                                                            context,
                                                            onTapFilter: () {
                                                      setState(() {
                                                        isJPublicationsFiltered =
                                                            true;
                                                      });
                                                    });
                                                  } else if (currentIndex ==
                                                      3) {
                                                    AppBottomSheet
                                                        .filterProfile(context,
                                                            onTapFilter: () {
                                                      setState(() {
                                                        isProfileFitered = true;
                                                      });
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      ImageOf.filerIcon,
                                                      height: 14.sp,
                                                    ),
                                                    XMargin(10.sp),
                                                    TextOf(
                                                      "Filter",
                                                      14.sp,
                                                      4,
                                                      color: AppColors
                                                          .primaryColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                          YMargin(12.sp),
                          tabBodies.elementAt(currentIndex)
                        ],
                      ),
                    ))
                  ],
                ),
    );
  }
}

class SeeAllTab extends ConsumerStatefulWidget {
  SeeAllTab(
      {required this.generalPublicationList,
      required this.researcherJobList,
      required this.userProfileList,
      super.key});

  PublicationsList generalPublicationList = [];
  ResearcherJobList researcherJobList = [];
  List<UserProfile>? userProfileList;

  @override
  ConsumerState<SeeAllTab> createState() => _SeeAllTabState();
}

class _SeeAllTabState extends ConsumerState<SeeAllTab> {
  // bool hasDone = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [TextOf("Jobs", 20.sp, 6)],
        ),

        ///[SEE ALL TAB]
        YMargin(16.sp),
        widget.researcherJobList.isEmpty
            ? SizedBox(
                width: 1.sw,
                height: 0.1.sh,
                child: Center(
                    child:
                        TextOf("No job is available at the moment!", 16.sp, 5)))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                    children:
                        List.generate(widget.researcherJobList.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 7.5.sp),
                    child: JobItem(
                        researcherJobModel: widget.researcherJobList[index]),
                  );
                }))),
        YMargin(12.sp),
        Row(
          children: [TextOf("Publications", 20.sp, 6)],
        ),
        YMargin(16.sp),
        widget.generalPublicationList.isEmpty
            ? SizedBox(
                width: 1.sw,
                height: 0.1.sh,
                child: Center(
                    child: TextOf(
                        "Publications are currently not available!", 16.sp, 5)))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(
                        widget.generalPublicationList.length, (index) {
                  PublicationModel publication =
                      widget.generalPublicationList[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 10.sp),
                    child: PublicationItem(
                        publicationList: widget.generalPublicationList,
                        width: 0.875.sw,
                        publicationModel: publication),
                  );
                }))),
        YMargin(12.sp),
        Row(
          children: [TextOf("People", 20.sp, 6)],
        ),
        YMargin(16.sp),
        (widget.userProfileList ?? []).isEmpty
            ? SizedBox(
                width: 1.sw,
                height: 0.1.sh,
                child: Center(
                    child: TextOf(
                        "People are not available right now!", 16.sp, 5)))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(
                        (widget.userProfileList ?? []).length,
                        (index) => Padding(
                              padding: EdgeInsets.only(right: 10.sp),
                              child: ProfileItem(
                                  padding: EdgeInsets.all(8.sp),
                                  userProfile: widget.userProfileList![index]),
                            )))),
      ],
    );
  }
}
