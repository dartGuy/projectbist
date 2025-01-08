import "package:flutter/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:project_bist/HELPERS/alert_dialog.dart";
import "package:project_bist/PROVIDERS/_base_provider/response_status.dart";
import "package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart";
import "package:project_bist/PROVIDERS/profile_provider/profile_provider.dart";
import "package:project_bist/PROVIDERS/publications_providers/publications_providers.dart";
import "package:project_bist/PROVIDERS/topic_providers/topic_providers.dart";
import "package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart";
import "package:project_bist/SERVICES/api_respnse.dart";
import "package:project_bist/SERVICES/api_service.dart";
import "package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart";
import "package:project_bist/WIDGETS/drawer_contents.dart";

List<StateNotifierProvider> providersToDispose = [
  publicationsProvider,
  topicsProvider,
  profileProvider,
  userJobsProvider,
  transactionProvider,
  researcherJobsProvider,
  researchersProfileProvider,
  escrowsProvider,
  researcherAppliedJobsProvider,
  generalPublicationsProvider,
  selectedDrawerProvider
];

class BaseProvider<ObjectType extends Object>
    extends StateNotifier<ResponseStatus> {
  final ApiService apiService = ApiService();
  BaseProvider()
      : super(ResponseStatus(
          responseState: ResponseState.LOADING,
        ));

  Future getRequest(
      {required BuildContext context,
      required String url,
      List<String>? headerKeys,
      showLoading = true,
      String? loadingMessage,
      bool inErrorCase = false}) async {
    if (inErrorCase == false && state.responseState == ResponseState.LOADING) {
      doGetRequest(context, url, showLoading, headerKeys, loadingMessage);
    } else if (inErrorCase == true &&
        state.responseState == ResponseState.ERROR) {
      Future.delayed(const Duration(seconds: 1), () {
        state = ResponseStatus(responseState: ResponseState.LOADING);
      });
      doGetRequest(context, url, showLoading, headerKeys, loadingMessage);
    }
  }

  void doGetRequest(BuildContext context, String url, showLoading,
      List<String>? headerKeys, String? loadingMessage) {
    apiService
        .apiRequest(context,
            url: url,
            method: Methods.GET,
            showLoading: showLoading,
            headerKeys: headerKeys ?? [Keys.AUTHORIZATION],
            loadingMessage: loadingMessage)
        .then((value) {
          print(value.data);
      if (value.status == true) {
        state =
            ResponseStatus(responseState: ResponseState.DATA, data: value.data);
      } else {
        state = ResponseStatus(
            responseState: ResponseState.ERROR, message: value.message);
      }
    });
  }

  Future<ApiResponse> makeRequest(
      {required BuildContext context,
      required String url,
      //required String getUrl,
      required Methods method,
      //  bool goToHomeOnGetAfterPostComplete = false,
      required Map<String, dynamic> formData,
      bool showAlerts = true,
      //String? loadingGetRequestMessage,
      List<String>? headerKeys,
      // required String syncSuccessMessage,
      String? loadingPostRequestMessage}) async {
    ApiResponse? requestData;
    assert(method != Methods.GET,
        "Only PATCH, PUT, POST or DELETE Methods are allowed!");
    await apiService
        .apiRequest(context,
            url: url,
            formData: formData,
            method: method,
            headerKeys: headerKeys,
            showLoading: showAlerts,
            loadingMessage: loadingPostRequestMessage)
        .then((value) {
      requestData = value;
      if (value.status == true) {
        if (showAlerts == true) {
          Alerts.openStatusDialog(context, description: value.message);
        }
      }
    });
    return requestData!;
  }
}
