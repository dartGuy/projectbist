import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/constants.dart';

class UploadToCloudinaryProvider {
  static Future<String> uploadDocument(BuildContext context,
      {required String localFilePath, String? loadingMessage}) async {
    String avatarUrl = "";

    Dio dio = Dio(BaseOptions(
      baseUrl: Endpoints.BASE_URL,
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));
    Alerts.showLoading(context, loadingMessage: loadingMessage);

    try {
      await dio
          .post(
        Endpoints.CLOUDINARY_API(AppConst.CLOUDINARY_CLOUD_NAME),
        data: FormData.fromMap(
          {
            "upload_preset": AppConst.CLOUDINARY_UPLOAD_PRESET,
            "file": await MultipartFile.fromFile(
              localFilePath,
              filename: localFilePath.split("/").last,
            )
          },
        ),
      )
          .then((value) {
        print(value.data);
        avatarUrl = value.data["url"];
      });
    } on DioException catch (e) {
      if (context.mounted) {
        Alerts.openStatusDialog(context,
            isSuccess: false,
            description: e.message ??
                e.response?.statusMessage ??
                "Something went wrong");
      }
    } catch (e) {
      if (context.mounted) {
        Alerts.openStatusDialog(context,
            isSuccess: false, description: e.toString());
      }
    }

    BotToast.cleanAll();

    return avatarUrl;
  }
}
