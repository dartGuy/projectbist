import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/methods.dart';
import "package:project_bist/MODELS/reseaecrers_review/researchers_review.dart";

final reviewsProvider =
    StateNotifierProvider<BaseProvider<ResearchersReview>, ResponseStatus>(
        (ref) => BaseProvider<ResearchersReview>());

class ReviewsProvider {
  //SEND_REVIEW_OR_REPORT_TO_ADMIN
  static final ApiService _apiService = ApiService();

  static Future sendReportOrReviewToAdmin(BuildContext context,
      {required String emailContent, required String messageType}) async {
    await _apiService
        .apiRequest(context,
            url: Endpoints.SEND_REVIEW_OR_REPORT_TO_ADMIN,
            method: Methods.POST,
            formData: {"emailContent": emailContent, "type": messageType},
            loadingMessage: "Sending $messageType to admin...")
        .then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            description:
                "${AppMethods.toTitleCase(messageType)} submitted successfully",
            isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          //ref.invalidate(userJobsProvider);
        });
      }
    });
  }
}
