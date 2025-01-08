import "package:project_bist/MODELS/notification_model/notification_model.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';

final notificationsProvider =
    StateNotifierProvider<BaseProvider<NotificationModel>, ResponseStatus>(
        (ref) => BaseProvider<NotificationModel>());

class NotificationsProvider {
  static final ApiService _apiService = ApiService();
  static deleteNotification(BuildContext context, WidgetRef ref,
      {required String notificationId}) {
    Navigator.pop(context);
    _apiService
        .apiRequest(context,
            url: Endpoints.DELETE_NOTIFICATION(notificationId),
            method: Methods.DELETE,
            loadingMessage: "Deleting this notification...")
        .then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            description: "Notification deleted successfully",
            isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          ref.invalidate(notificationsProvider);
        });
      }
    });
  }

  static deleteAllNotifications(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    _apiService
        .apiRequest(context,
            url: Endpoints.DELETE_ALL_NOTIFICATIONS,
            method: Methods.DELETE,
            loadingMessage: "Deleting all notifications...")
        .then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            description: "All notifications deleted successfully",
            isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          ref.invalidate(notificationsProvider);
        });
      }
    });
  }
}
