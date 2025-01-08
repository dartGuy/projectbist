import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:project_bist/HELPERS/alert_dialog.dart";

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class LaunchUrl {
  static Future launchEmailAddress(BuildContext context,
      {required String emailAddress,
      required String emailSubject,
      required String emailBody}) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: encodeQueryParameters(
          <String, String>{'subject': emailSubject, "body": emailBody}),
    );
    try {
      await launchUrl(
        url,
        //mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (context.mounted) {
        Alerts.openStatusDialog(context,
            description: "Unable to launch email!", isSuccess: false);
      }
    }
  }

  static Future launchWebsite(BuildContext context,
      {required String websiteLink, LaunchMode? mode}) async {
    final Uri url = Uri(
      scheme: 'https',
      path: websiteLink,
    );

    try {
      await launchUrl(
        url,
        mode: mode ?? LaunchMode.externalApplication,
      );
    } catch (e) {
      if (context.mounted) {
        Alerts.openStatusDialog(context,
            description: "Unable to launch $websiteLink", isSuccess: false);
      }
    }
  }
}
