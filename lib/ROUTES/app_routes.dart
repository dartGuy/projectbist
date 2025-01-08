import 'package:flutter/material.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/MODELS/publication_models/publication_draft.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/VIEWS/account_flow/about_us.dart';
import 'package:project_bist/VIEWS/account_flow/change_passwowrd.dart';
import 'package:project_bist/VIEWS/account_flow/edit_profile.dart';
import 'package:project_bist/VIEWS/account_flow/faqs.dart';
import 'package:project_bist/VIEWS/account_flow/portfolio_of_researcher.dart';
import 'package:project_bist/VIEWS/account_flow/preview_profile.dart';
import 'package:project_bist/VIEWS/account_flow/account_home.dart';
import 'package:project_bist/VIEWS/account_flow/privacy_and_policy.dart';
import 'package:project_bist/VIEWS/account_flow/privacy_home.dart';
import 'package:project_bist/VIEWS/account_flow/review_screen.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/add_new_project_flow.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/confirm_post_screen.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/all_nav_screens/home_pages/client_home_page.dart';
import 'package:project_bist/VIEWS/all_nav_screens/home_pages/researcher_home_screens.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/auths/check_your_mail.dart';
import 'package:project_bist/VIEWS/auths/create_account_screens_ALL_USERS.dart';
import 'package:project_bist/VIEWS/auths/forgot_password.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/VIEWS/auths/otp_screen.dart';
import 'package:project_bist/VIEWS/auths/reset_password_screen.dart';
import 'package:project_bist/VIEWS/change_theme/change_theme.dart';
import 'package:project_bist/VIEWS/clients_job_profile/clients_job_profile.dart';
import 'package:project_bist/VIEWS/contact_us/contact_us.dart';
import 'package:project_bist/VIEWS/firebase_initialization_error/firebase_initialization_error.dart';
import 'package:project_bist/VIEWS/job_description_pages/clients_job_description.dart';
import 'package:project_bist/VIEWS/job_description_pages/job_description_page.dart';
import 'package:project_bist/VIEWS/make_report_screen/make_report_screen.dart';
import 'package:project_bist/VIEWS/messaging/chats_list_screen.dart.dart';
import 'package:project_bist/VIEWS/messaging/client_view_researchers_profile.dart';
import 'package:project_bist/VIEWS/messaging/search_available_chat.dart';
import 'package:project_bist/VIEWS/messaging/researcher_view_client_profile.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/client_decline_project.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/client_file_for_refund.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/client_pause_job.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/escrow_details.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/client_request_support_on_project.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/fund_escrow_screen.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/my_job_and_escrow_flow.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/activity_preview.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/add_submission_plan.dart';
import 'package:project_bist/VIEWS/my_publications/my_publications.dart';
import 'package:project_bist/VIEWS/notification_screen/notification_screen.dart';
import 'package:project_bist/VIEWS/onboardings/intro_screens.dart';
import 'package:project_bist/VIEWS/onboardings/splash_screen.dart';
import 'package:project_bist/VIEWS/originality_test_flow/__originality_test_flow.dart';
import 'package:project_bist/VIEWS/originality_test_flow/ai_detetction_detail.dart';
import 'package:project_bist/VIEWS/originality_test_flow/plagarism_detail.dart';
import 'package:project_bist/VIEWS/publication_detail/publication_detail_from_dashboard.dart';
import 'package:project_bist/VIEWS/publication_detail/publicaton_detail_info_unpurchased.dart';
import 'package:project_bist/VIEWS/publication_detail/view_publication_to_download.dart';
import 'package:project_bist/VIEWS/request_process_status_page/request_process_status_page.dart';
import 'package:project_bist/VIEWS/reseaechers_publications_screen/reseaechers_publications_screen.dart';
import 'package:project_bist/VIEWS/reseaechers_reviews_screen/reseaechers_reviews_screen.dart';
import 'package:project_bist/VIEWS/research_notes_flow/research_note_reading_page.dart';
import 'package:project_bist/VIEWS/research_notes_flow/research_notes_flow.dart';
import 'package:project_bist/VIEWS/researcher_publish_paper_page/researcher_publish_paper_page.dart';
import 'package:project_bist/VIEWS/researcher_suggest_topic_page/researcher_suggest_topic_page.dart';
import 'package:project_bist/VIEWS/researchers_profile_screen/researchers_profile_screen.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/search_topic.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/filtered_topic.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/topics_list_preview_screen.dart';
import 'package:project_bist/VIEWS/messaging/chatting_page.dart';
import 'package:project_bist/VIEWS/client_generate_payment/client_generate_payment.dart';
import "package:project_bist/VIEWS/client_generate_payment/select_wallet_to_pay.dart";
import 'package:project_bist/VIEWS/add_new_project_flow/assistance_agreement.dart';
import 'package:project_bist/VIEWS/wallet_processes/client_select_escrow_to_fund.dart';
import 'package:project_bist/VIEWS/wallet_processes/create_wallet.dart';
import 'package:project_bist/VIEWS/wallet_processes/filter_transaction.dart';
import 'package:project_bist/VIEWS/wallet_processes/flud_wallet_screen.dart';
import 'package:project_bist/VIEWS/wallet_processes/wallet_home.dart';
import 'package:project_bist/VIEWS/wallet_processes/wallet_onboarding.dart';
import 'package:project_bist/VIEWS/wallet_processes/withdraw_screen.dart';
import 'package:project_bist/VIEWS/web_view_page/web_view_page.dart';

import '../MODELS/message_model/single_chat_model.dart';
import '../WIDGETS/cupertino_widget.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    var argument = settings.arguments;
    print("APP_ROUTE: /${settings.name}");
    AppConst.APP_ROUTE = settings.name!;
    return switch (settings.name) {
      SplashScreen.splashScreen => screenOf(screenName: const SplashScreen()),
      AllNavScreens.allNavScreens => screenOf(
            screenName: AllNavScreens(
          currentIndex: argument as int?,
        )),
      IntroScreens.introScreens => screenOf(screenName: const IntroScreens()),
      BeginUserDetermination.beginUserDetermination =>
        screenOf(screenName: const BeginUserDetermination()),
      StudentOrProffesionalDeterminatinScreen
            .studentOrProffesionalDeterminatinScreen =>
        screenOf(screenName: const StudentOrProffesionalDeterminatinScreen()),
      AllUsersCreateAccountScreen.allUsersCreateAccountScreen => screenOf(
            screenName: AllUsersCreateAccountScreen(
          userTypes: argument as UserTypes,
        )),
      LoginScreen.loginScreen => screenOf(screenName: const LoginScreen()),
      ForgotPasswordScreen.forgotPasswordScreen =>
        screenOf(screenName: const ForgotPasswordScreen()),
      OTPScreen.otpScreen =>
        screenOf(screenName: OTPScreen(emailAddress: argument as String?)),
      ResetPasswordScreen.resetPasswordScreen =>
        screenOf(screenName: const ResetPasswordScreen()),
      ResearcherHomeScreen.researcherHomeScreen =>
        screenOf(screenName: ResearcherHomeScreen(callback: argument as VoidCallback)),
      JobDescriptionPage.jobDescriptionPage => screenOf(
          screenName: JobDescriptionPage(
              jobDescriptionPageArgument:
                  argument as JobDescriptionPageArgument)),
      ResearchersProfileScreen.researchersProfileScreen => screenOf(
          screenName:
              ResearchersProfileScreen(userProfile: argument as UserProfile?)),
      ResearchersReviewsScreen.researchersReviewsScreen =>
        screenOf(screenName: const ResearchersReviewsScreen()),
      ClientsJobDescription.clientsJobDescription => screenOf(
          screenName: ClientsJobDescription(jobModel: argument as JobModel)),
      ResearchersPublicationsScreen.researchersPublicationsScreen => screenOf(
          screenName: ResearchersPublicationsScreen(
              publicationsList: argument as PublicationsList)),
      TopicsListPreviewScreen.topicsListPreviewScreen => screenOf(
            screenName: TopicsListPreviewScreen(
          isExploreTopic: argument as bool?,
        )),
      ClientHomePage.clientHomePage =>
        screenOf(screenName: ClientHomePage(callback: argument as VoidCallback)),
      ResearchPublishPaperScreen.researchPublishPaperScreen => screenOf(
          screenName: ResearchPublishPaperScreen(
              publicationDraft: argument as PublicationDraft?)),
      RequestStatusPage.requestStatusPage => screenOf(
            screenName: RequestStatusPage(
          requesStatusPageArgument: argument as RequestStatusPageArgument,
        )),
      ResearchSuggestTopicPage.researchSuggestTopicPage =>
        screenOf(screenName: const ResearchSuggestTopicPage()),
      SearchTopicPage.searchTopicPage => screenOf(
          screenName: SearchTopicPage(
              searchTopicPageArgument: argument as SearchTopicPageArgument)),
      FilteredTopicPage.filteredTopicPage => screenOf(
          screenName: FilteredTopicPage(
              filteredTopicPageArgument:
                  argument as FilteredTopicPageArgument)),
      AvailableChatsList.availableChatsList => screenOf(
          screenName: AvailableChatsList(isHamburger: argument as bool?)),
      SearchvailableChatsPage.searchvailableChatsPage => screenOf(
          screenName: const SearchvailableChatsPage()),
      ChattingPage.chattingPage => screenOf(
          screenName: ChattingPage(
              chattingPageArgument: argument as ChattingPageArgument),
        ),
      ResearcherViewClientProfileScreen.researcherViewClientProfileScreen =>
        screenOf(
            screenName:
                ResearcherViewClientProfileScreen(user: argument as User)),
      ClientGeneratePayment.clientGeneratePayment => screenOf(
          screenName:
              ClientGeneratePayment(userProfile: argument as UserProfile)),
      SelectWalletToPayScreen.selectWalletToPayScreen => screenOf(
          screenName: SelectWalletToPayScreen(
              selectWalletToPayScreenArgument:
                  argument as SelectWalletToPayScreenArgument?)),
      ClientViewResearchersProfileScreen.clientViewResearchersProfileScreen =>
        screenOf(
            screenName: ClientViewResearchersProfileScreen(
                clientViewResearchersProfileScreenArgument:
                    argument as ClientViewResearchersProfileScreenArgument)),
      AddNewProjectFlow.addNewProjectFlow => screenOf(
          screenName: AddNewProjectFlow(
              addNewProjectFlowArgument:
                  argument as AddNewProjectFlowArgument)),
      ConfirmPostScreen.confirmPostScreen => screenOf(
          screenName: ConfirmPostScreen(
              confirmPostScreenArgument:
                  argument as ConfirmPostScreenArgument)),
      AssistanceAgreementFlow.assistanceAgreementFlow => screenOf(
            screenName: AssistanceAgreementFlow(
          assistanceAgreementFlowArgument:
              argument as AssistanceAgreementFlowArgument,
        )),
      OriginalityTestFlow.originalityTestFlow =>
        screenOf(screenName: const OriginalityTestFlow()),
      PlagarismDetail.plagarismDetail =>
        screenOf(screenName: const PlagarismDetail()),
      AiDetectionDetailsPage.aiDetectionDetailsPage =>
        screenOf(screenName: const AiDetectionDetailsPage()),
      WalletSetup.walletSetup => screenOf(screenName: const WalletSetup()),
      CreateWallet.createWallet => screenOf(screenName: const CreateWallet()),
      WalletHomePage.walletHomePage =>
        screenOf(screenName: const WalletHomePage()),
      WithdrawScreen.withdrawScreen =>
        screenOf(screenName: const WithdrawScreen()),
      FundWalletScreen.fundWalletScreen =>
        screenOf(screenName: const FundWalletScreen()),
      AccountHomePage.accountHomePage =>
        screenOf(screenName: const AccountHomePage()),
      PrivacyPage.privacyPage => screenOf(screenName: const PrivacyPage()),
      PrivacyAndPolicy.privacyAndPolicy =>
        screenOf(screenName: const PrivacyAndPolicy()),
      AboutUs.aboutUs => screenOf(screenName: const AboutUs()),
      FaqsScreen.faqsScreen => screenOf(screenName: const FaqsScreen()),
      ChangePassword.changePassword =>
        screenOf(screenName: const ChangePassword()),
      ReviewsScreen.reeviewScreen =>
        screenOf(screenName: const ReviewsScreen()),
      PortfolioOfResearcher.portfolioOfResearcher =>
        screenOf(screenName: const PortfolioOfResearcher()),
      MyJosbAndEscrowFlow.myJosbAndEscrowFlow =>
        screenOf(screenName: const MyJosbAndEscrowFlow()),
      EscrowDetailScreen.escrowDetailScreen => screenOf(
            screenName: EscrowDetailScreen(
          escrowDetails: argument as EscrowWithSubmissionPlanModel?,
        )),
      JobActivityPreview.jobActivityPreview => screenOf(
          screenName: JobActivityPreview(
              escrowData: argument as EscrowWithSubmissionPlanModel)),
      SubscriptionPlanScreen.subscriptionPlanScreen => screenOf(
          screenName: SubscriptionPlanScreen(
              argument: argument as SubscriptionPlanScreenArgument)),
      ViewSingleActivity.viewSingleActivity => screenOf(
          screenName: ViewSingleActivity(
              viewSingleActivityArgument:
                  argument as ViewSingleActivityArguments)),
      ClientDeclineProject.clientDeclineProject =>
        screenOf(screenName: ClientDeclineProject(planId: argument as String)),
      ClientRequestSupportOnProject.clientRequestSupportOnProject => screenOf(
          screenName: ClientRequestSupportOnProject(jobId: argument as String)),
      ClientPauseJob.clientPauseJob =>
        screenOf(screenName: ClientPauseJob(jobId: argument as String)),
      ClientFileForRefund.clientFileForRefund =>
        screenOf(screenName: const ClientFileForRefund()),
      PublicationDetailFromDashboard.publicationDetailFromDashboard => screenOf(
          screenName: PublicationDetailFromDashboard(
              publicationDetailFromDashboardArgument:
                  argument as PublicationDetailFromDashboardArgument)),
      PublicationDetailInfoUnpurchased.publicationDetailInfoUnpurchased =>
        screenOf(
            screenName: PublicationDetailInfoUnpurchased(
          publicationModel: argument as PublicationModel,
        )),
      ViewPublicationToDownload.viewPublicationToDownload => screenOf(
          screenName: ViewPublicationToDownload(
              publicationModel: argument as PublicationModel)),
      MyPublicationsScreen.myPublicationsScreen => screenOf(
          screenName: MyPublicationsScreen(allowExit: argument as bool?)),
      MakeReportScreen.makeReportScreen =>
        screenOf(screenName: const MakeReportScreen()),
      ResearchNotesFlow.researchNotesFlow =>
        screenOf(screenName: const ResearchNotesFlow()),
      ResearchNotesReadingPage.researchNotesReadingPage => screenOf(
          screenName: ResearchNotesReadingPage(pageTogo: argument as int)),
      ChangeThemeScreen.changeThemeScreen =>
        screenOf(screenName: const ChangeThemeScreen()),
      EditProfile.editProfile => screenOf(
            screenName: EditProfile(
          userProfile: argument as UserProfile,
        )),
      WebViewPage.webViewPage => screenOf(
          screenName: WebViewPage(
              webViewPageArgument: argument as WebViewPageArgument)),
      PreviewProfile.previewProfile =>
        screenOf(screenName: const PreviewProfile()),
      CheckYourMail.checkYourMail =>
        screenOf(screenName: CheckYourMail(email: argument as String?)),
      FilterTransaction.filterTransaction =>
        screenOf(screenName: const FilterTransaction()),
      ContactUs.contactUs => screenOf(screenName: const ContactUs()),
      NotificationScreen.notificationScreen => screenOf(
          screenName:
              NotificationScreen(tabController: argument as TabController)),
      ClientsJobProfile.clientsJobProfile => screenOf(
          screenName: ClientsJobProfile(userProfile: argument as UserProfile)),
      FundEscrow.fundEscrow => screenOf(
            screenName: FundEscrow(
          fundEscrowArgument: argument as FundEscrowArgument,
        )),
      FirebaseInitializationErrorPage.firebaseInitializationError => screenOf(
            screenName: FirebaseInitializationErrorPage(
          errorMessage: argument as String?,
        )),
      ClientSelectEscrowToFund.clientSelectEscrowToFund =>
        screenOf(screenName: const ClientSelectEscrowToFund()),
      _ => screenOf(
            screenName: const Center(
          child: Text(
            "Page not found!",
            style: TextStyle(fontSize: 3000),
          ),
        ))
    };
  }
}

CupertinoPageRoute screenOf({required Widget screenName}) {
  return CupertinoPageRoute(builder: (context) => screenName);
}
