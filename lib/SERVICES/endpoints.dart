// ignore_for_file: non_constant_identifier_names

class Endpoints {
  static String BASE_URL = "https://api.projectbist.com/";

//58 endpoints in total
  /// ====================== [Authentications]==========================
  /// ====================== [Authentications]==========================
  /// ====================== [Authentications]==========================
  static String LOGIN = "login";
  static String RESEARCHER_SIGNUP = "researchers/sign-up";
  static String PROFESSIONAL_SIGNUP = "professionals/sign-up";
  static String STUDENT_SIGNUP = "students/sign-up";
  static String RESEND_CONFIRMATION_MAIL({required String email}) =>
      "resend-confirmation-email?email=$email";
  static String EMAIL_USERNAME_AVAILABILITY(String userKind,
          {required String email, required String username}) =>
      "$userKind/available?email=$email&userName=$username";
  static String LOGOUT = "logout";

  /// ====================== [Account_Recovery] ==========================
  /// ====================== [Account_Recovery] ==========================
  /// ====================== [Account_Recovery] ==========================
  static String SEND_PASSWORD_RESET_TOKEN = "account-recovery/initiate";
  static String VERIFY_PASSWORD_RESET_TOKEN = "verify-password-token";
  static String COMPLETE_ACCOUNT_RECOVERY = "account-recovery/complete";

  /// ====================== [Change_Password] ===========================
  static String CHANGE_PASSWORD(String oldPassword, String newPassword) =>
      "accounts/change-password?newPassword=$newPassword&currentPassword=$oldPassword";

  /// ======================== [User_Profile] ===========================
  /// ======================== [User_Profile] ===========================
  /// ======================== [User_Profile] ===========================
  static String GET_PROFILE = "accounts/return-details";
  static String EDIT_PROFILE_RESEARCHER = "accounts/researchers";
  static String EDIT_PROFILE_PROFESSIONAL = "accounts/professionals";
  static String EDIT_PROFILE_STUDENT = "accounts/students";
  static String DELETE_ACCOUNT = "accounts/delete-account";
  static String FETCH_ALL_RESEARCHER_PROFILES = "researchers";
  static String FETCH_RESEARCHER_PROFILE (String researcherId) => "researchers/$researcherId/profile";

  /// ======================= [Cloudinary_Image_Upload]
  static String CLOUDINARY_API(String cloudName) =>
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  /// ======================= [Transaction_and_Verification] ==================
  /// ======================= [Transaction_and_Verification] ==================
  /// ======================= [Transaction_and_Verification] ==================
  static String SUBMIT_KYC = "submit-kyc";
  static String FUND_WALLET(String amount) => "fund-wallet?amount=$amount";
  static String DEBIT_WALLET = "debit-wallet";
  static String GET_BANKS = "fetch-banks?currency=NGN";

  static String VERIFY_ACCOUNT_NUMBER(
          {required String accountNumber, required String bankCode}) =>
      "verify-account?accountNumber=$accountNumber&bankCode=$bankCode";
  static String RESEARCHER_SUGGEST_TOPIC = "suggest-topic";
  static String FETCH_WALLET = "fetch-wallet";

  static String LIKE_AND_UNLIKE_TOPIC(String topicId) => "topic/$topicId/like";
  static String FILTER_TRANSACTIONS = "fetch-transactions";

  /// =============================== [Publications] =====================================
  /// =============================== [Publications] =====================================
  /// =============================== [Publications] =====================================
  static String CREATE_PUBLICATION = "publications";
  static String SUBMIT_DOCUMENT_PLAGIARISM = "plagiarism/upload-file";
  static String AI_CONTENT_CHECK = "ai-content/check";
  static String GENERAL_PUBLICATIONS_LIST = "publications/general";
  static String RESEARCHERS_PUBLICATIONS = "publications";
  static String RESEARCHER_BOUGHT_PUBLICATIONS = "publications/researcher";
  static String CLIENTS_BOUGHT_PUBLICATIONS = "publications/client";
  static String PURCHASE_PUBLICATION(String publicationId) =>
      "publications/purchase/$publicationId";
  static String DELETE_PUBLICATION(String publicationId) =>
      "publications/$publicationId";
  static String FETCH_TOPICS = "topics";
  static String LIKE_AND_UNLIKE_PUBLICATION(String publicationId) =>
      "publication/$publicationId/like";

  /// ============================== [Jobs_Related] ======================================
  /// ============================== [Jobs_Related] ======================================
  /// ============================== [Jobs_Related] ======================================
  static String CLIENTS_POSTED_JOBS_FETCH = "jobs";
  static String CLIENT_DEACTIVATE_JOB_APPLICATION(String jobId) =>
      "jobs/$jobId";
  static String RESEARCHER_FETCH_ALL_JOBS = "jobs/general";
  static String RESEARCHER_APPLY_FOR_JOB(String jobId) => "jobs/$jobId/apply";
  static String RESEARCHER_APPLIED_JOBS = "researcher/applied-jobs";
  static String RESEARCHER_WITHDRAW_APPLICATION(String jobId) =>
      "jobs/$jobId/withdraw-application";
  static String CLIENT_DELETE_JOB(String jobId) => "jobs/$jobId";
  static String  CLIENT_PAUSE_ESCROW_JOB(String jobId) => 'jobs/$jobId/pause-job';

  /// ============================== [Escrow_Related] ====================================
  /// ============================== [Escrow_Related] ====================================
  /// ============================== [Escrow_Related] ====================================
  static String CREATE_ESCROW_FROM_RESEARCHERS_PROFILE(
          {required String researcherId,
          required String jobId,
          required String projectFee}) =>
      "escrows/researchers/$researcherId/jobs/$jobId?projectFee=${int.tryParse(projectFee)}";

  static String CREATE_ESCROW_AS_YOU_GOO({required String researcherId}) =>
      "escrows/researchers/$researcherId/jobs/$researcherId/pay";
  static String FETCH_ESCROWS(String userType) => "$userType/escrows";
  static String JOBS_APPLIED_BY_RESEARCHER(String researcherId) =>
      "researcher/$researcherId/jobs";
  static String USER_PROFILE_FROM_ID(
          {String? researcherId, String? clientId}) =>
      "${researcherId != null ? "researchers/$researcherId" : "clients/$clientId!"}/profile";
  static String FUND_ESCROW({required String escrowId, required int amount}) =>
      "escrows/$escrowId/fund?amount=$amount";
  static String DELETE_ESCROW(String escrowId) => "escrows/$escrowId";
  static String CLIENT_COMPLETE_ESCROW_JOB(String escrowId) => "client/escrows/$escrowId/complete";

  /// =========================== [Escrow_Submission_Plan] ==============================
  /// =========================== [Escrow_Submission_Plan] ==============================
  /// =========================== [Escrow_Submission_Plan] ==============================
  static String APPROVE_SUBMISSION_PLAN(String planId) =>
      "escrows/plans/$planId/approve";
  static ADD_SUBMISSION_PLAN(String escrowId) => "escrows/$escrowId/plans";
  static String DECLINE_SUBMISSION_PLAN(String planId) =>
      "escrows/plans/$planId/decline";
  static String RESEARCHER_SUBMIT_SUBMISSION_PLAN_ATTACHMENT(String planId) => "plans/$planId";
  static String REQUEST_FOR_REVIEW_OF_SUBMISSION_PLAN(
          {required String planId}) =>
      "escrows/plans/$planId/review";

  /// =========================== [Review_AND_Report] ==============================
  /// =========================== [Review_AND_Report] ==============================
  /// =========================== [Review_AND_Report] ==============================
  static String FETCH_RESEARCHERS_REVIEWS(String researcherId) =>
      "reviews/researcher/$researcherId";
  static String SEND_REVIEW_OR_REPORT_TO_ADMIN = "send-admin-message";
  static String CLIENT_REVIEW_RESEARCHER (String researcherId)=> "reviews/researcher/$researcherId";

  /// =========================== [NOTIFICATIONS_AVAILABLE] ==============================
  /// =========================== [NOTIFICATIONS_AVAILABLE] ==============================
  /// =========================== [NOTIFICATIONS_AVAILABLE] ==============================
  static String NOTIFICATION_GENERAL = "notifications";
  static String DELETE_NOTIFICATION(String notificationId) =>
      "notifications/$notificationId";
  static String DELETE_ALL_NOTIFICATIONS = "notifications";

  ///==============================[CHATS]================================================
  ///==============================[CHATS]================================================
  ///==============================[CHATS]================================================
 static String FETCH_OR_CREATE_CHAT(String recipientId, String recipientRole) => "chats/fetch-or-create-chat?recipientId=$recipientId&recipientRole=$recipientRole";
}

// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as https;


// String minWindowSubstring(List strArr) {
//   List<String> types = [];
//   Map check = {};
//   strArr[1].split("").toList().forEach((e){
//   Map dd =  Map.from({e: strArr[1].split("").toList().where((x)=> x==e).length});
//   check.addAll(dd);
//   });
//   for(int i = 0; i< strArr.length; i++){
//     int s = i, n = strArr.length-1;
//     String main = strArr[0];
//     types;
//     while(main.split("").toList().any((e)=> strArr[1].contains(e) )){
//       types.add(main);
//       if(){}
//     }

//   }
//   return strArr[0];

// }

// var url = Uri.parse('https://coderbyte.com/api/challenges/json/date-list');
// var request = await https.get(url);
// List<dynamic> raw = jsonDecode(request.body);
// List<Map<String, dynamic>> aa = [];
// List<dynamic> keys = raw
//     .map((e) => e.keys.toList()..sort())
//     .toList(); //[["a", "b", "c"], ["d", "e", "f"]]
// List<Map<String, dynamic>> sortedMaps = keys.map((e) {
//   var map = <String, dynamic>{};
//   e.forEach((key) {
//     map[key] =
//         aa.firstWhere((element) => element.containsKey(key));
//   });
//   return map;
// }).toList();

// print(sortedMaps);

// [
//   {
//     "name":"John",
//     "age":30,
//     "city":"New York",
//     "country":"USA",
//     "Hobbies":
//       ["reading","swimming","hiking"],
//     "occupation":"programmer",
//     "favorite_foods":
//       {"Breakfast":"pancakes","Lunch":"sandwich","dinner":"pasta"}

//   }
// ]

// import 'package:http/http.dart' as http;
// import 'dart:convert.dart'

//25, 24,
//25, 24,
