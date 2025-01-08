// ignore_for_file: constant_identifier_names

import "package:bot_toast/bot_toast.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";
import "package:project_bist/CORE/app_models.dart";
import "package:project_bist/HELPERS/alert_dialog.dart";
import "package:project_bist/SERVICES/api_respnse.dart";
import "package:project_bist/SERVICES/endpoints.dart";
import "package:project_bist/UTILS/constants.dart";
import "package:project_bist/UTILS/methods.dart";
import "package:project_bist/VIEWS/auths/login_screens.dart";
import "package:project_bist/VIEWS/wallet_processes/create_wallet.dart";
import "package:project_bist/main.dart";

enum Methods { GET, POST, PUT, PATCH, DELETE, DOWNLOAD }

enum LikeItem { like, unlike, neutral }

class ApiService {
  static const Duration _timeout = Duration(seconds: 60);
  Dio? _dio;
  Map<String, String>? headers;
  ApiResponse? _apiResponse;
  ApiResponse get getResponse => _apiResponse!;
  set setResponse(data) => _apiResponse = data;
  bool hasAuthToken = true;

  ApiService({bool hasBearerToken = true}) {
    if (hasBearerToken == false) {
      hasAuthToken = false;
    }
  }

  Future<ApiResponse> apiRequest(
    BuildContext context, {
    required String url,
    required Methods method,
    String dataKey = "data",
    bool showLoading = true,
    Map<String, dynamic>? formData,
    List<String>? headerKeys,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onReceivedDownloadProgressProgress,
    String? loadingMessage,
  }) async {
    if (showLoading == true) {
      Alerts.showLoading(context, loadingMessage: loadingMessage);
    }

    String token =
        getIt<AppModel>().appCacheBox!.get(AppConst.TOKEN_KEY) ?? "token";

    headers = {
      Keys.X_AUTH_CODE: token,
      Keys.TOKEN: token,
      Keys.X_TOKEN: token,
      Keys.AUTHORIZATION: "Bearer $token"
    };

    if (hasAuthToken == false) {
      headers!.remove(Keys.AUTHORIZATION);
    }
    var mapEntry = headers!.entries
        .where((e) => (headerKeys ?? headers!.keys).contains(e.key));

    _dio = Dio(BaseOptions(
      headers: Map.fromEntries(mapEntry),
      baseUrl: Endpoints.BASE_URL,
      receiveTimeout: _timeout,
      sendTimeout: _timeout,
      connectTimeout: _timeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));
    _dio!.interceptors.add(PrettyDioLogger(
        error: true,
        request: true,
        requestBody: false,
        requestHeader: false,
        responseBody: false));
    FocusScope.of(context).unfocus();
    try {
      if (method == Methods.GET) {
        await _dio!
            .get(url,
                cancelToken: cancelToken, queryParameters: queryParameters)
            .then((value) => setResponse = ApiResponse.fromJson(json: {
                  "message": value.data["message"],
                  "data": value.data[dataKey],
                  "status": true
                }));
      } else if (method == Methods.POST) {
        await _dio!
            .post(url,
                cancelToken: cancelToken,
                data: formData == null ? null : FormData.fromMap(formData))
            .then((value) {
          return setResponse = ApiResponse.fromJson(json: {
            "message": value.data["message"],
            "data": value.data[dataKey],
            "status": true
          });
        });
      } else if (method == Methods.PUT) {
        await _dio!
            .put(url,
                cancelToken: cancelToken, data: FormData.fromMap(formData!))
            .then((value) => setResponse = ApiResponse.fromJson(json: {
                  "message": value.data["message"],
                  "data": value.data[dataKey],
                  "status": true
                }));
      } else if (method == Methods.PATCH) {
        await _dio!
            .patch(url,
                cancelToken: cancelToken, data: FormData.fromMap(formData!))
            .then((value) => setResponse = ApiResponse.fromJson(json: {
                  "message": value.data["message"],
                  "data": value.data[dataKey],
                  "status": true
                }));
      } else if (method == Methods.DELETE) {
        await _dio!.delete(url, cancelToken: cancelToken).then((value) =>
            setResponse = ApiResponse.fromJson(json: {
              "message": value.data["message"],
              "data": value.data[dataKey],
              "status": true
            }));
      }
    } on DioException catch (e) {
      setResponse = ApiResponse(
          message: switch (e.type) {
        DioExceptionType.connectionError => "Internet connection error!",
        DioExceptionType.cancel => "Request canceled!",
        DioExceptionType.connectionTimeout => "Connect timeout!",
        DioExceptionType.sendTimeout => "Send timeout",
        DioExceptionType.receiveTimeout => "Receive timeout!",
        DioExceptionType.unknown => "Unknown error, try again!",
        _ => switch (e.response?.data == null) {
            true => e.response?.statusMessage,
            false => url.contains("cloudinary")
                ? e.response?.data["error"]["message"]
                : (e.response?.data["message"]).toString() ??
                    e.response?.statusMessage.toString(),
          }
      });
    } catch (e) {
      setResponse = ApiResponse(message: e.toString());
    }

    if (_apiResponse!.status == false &&
            showLoading == true &&
            context.mounted &&
            _apiResponse!.message != AppConst.YET_TO_VERIFY_EMAIL ||
        _apiResponse!.message.toLowerCase() ==
            AppConst.CREDENTIAL_ALREADY_IN_USE.toLowerCase()) {
      if (context.mounted) {
        Alerts.openStatusDialog(context,
            description: AppMethods.toTitleCase(_apiResponse!.message),
            isSuccess: false);
      }
    } else if (_apiResponse!.message.toLowerCase() ==
        AppConst.CREDENTIAL_ALREADY_IN_USE.toLowerCase()) {
      if (context.mounted) {
        Alerts.optionalDialog(context,
            text: _apiResponse!.message,
            left: "Cancel",
            right: "Login", onTapRight: () {
          Navigator.pushNamed(context, LoginScreen.loginScreen);
        });
      }
    }
    if (_apiResponse!.message
            .toLowerCase()
            .contains(AppConst.ACCESS_FORBIDDEN.toLowerCase()) ||
        _apiResponse!.message.toLowerCase() ==
            AppConst.ESCROW_CREATION_FAILED_ERROR ||
        _apiResponse!.message.toLowerCase() ==
            "invalid token attached to header" && AppConst.APP_ROUTE != LoginScreen.loginScreen) {
      Future.delayed(const Duration(seconds: 2), () {
        getIt<AppModel>().appCacheBox!.put(AppConst.TOKEN_KEY, "");
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context,
              _apiResponse!.message.toLowerCase() ==
                      AppConst.ESCROW_CREATION_FAILED_ERROR
                  ? CreateWallet.createWallet
                  : LoginScreen.loginScreen,
              (_) => false);
        }
      });
    }
    BotToast.cleanAll();
    return getResponse;
  }
}

class Keys {
  static const String X_AUTH_CODE = "x-auth-code";
  static const String TOKEN = "Token";
  static const String X_TOKEN = "x-token";
  static const String  AUTHORIZATION = "Authorization";
}