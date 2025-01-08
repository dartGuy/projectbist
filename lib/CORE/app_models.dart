// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_bist/CORE/app_interface.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/MODELS/publication_models/publication_draft.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project_bist/main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class AppModel implements AppInterface {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// =============================== [App initializations] =======================
  /// =============================== [App initializations] =======================
  /// =============================== [App initializations] =======================
  @override
  Future<void> initApp() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    await requestNotificationPermission();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    debugPrint("FCM Token: $fcmToken");
    await Hive.initFlutter();
    Hive.registerAdapter(PublicationDraftAdapter());
    await Hive.openBox<PublicationDraft>(AppConst.PUBLICATION_DRAFT_KEY);
    getIt<AppModel>().appCacheBox = await Hive.openBox(AppConst.APP_CACHE_BOX);
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    getIt<AppModel>().appCacheBox!.put(AppConst.USER_DEVICE_TOKEN, fcmToken);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Future<File?> uploadFile(BuildContext context,
      {List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: allowedExtensions, type: FileType.custom);

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // ignore: use_build_context_synchronously
      Alerts.openStatusDialog(context,
          title: "Upload failed",
          isSuccess: false,
          description:
              "Unable to complete document upload. Only .docx, .pdf, .txt and .pptx documents type are allowed. Please try again!");
      return null;
    }
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  UserProfile? userProfile;
  Box? appCacheBox;
  MyJobsList? myJobsList;
  ResearcherJobList? researcherJobList;
  TransactionList? transactionList;
  PublicationsList? generalPublicationList,
      boughtPublicationList,
      postedPublicationList,
      inReviewPublicationList,
      draftPublicationList,
      researchersPersonalPublications;
  EscrowWithSubmissionPlanList? escrowWithSubmissionPlanList;
  ResearcherProfilesList? researcherProfilesList;
  TopicsList? topicsList;
  ResearcherAppliedJobsList? researcherAppliedJobsList;
  ResearchersReviewsList? researchersReviewsList;
  NotificationsList? notificationsList;
  Set<Map<String, File>> projectBistFiles = {};
}
