import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';

import '../../core.dart';

final topicsProvider =
    StateNotifierProvider<BaseProvider<ExploreTopicsModel>, ResponseStatus>(
        (ref) => BaseProvider<ExploreTopicsModel>());

class TopicsProvider {
  static final ApiService _apiService = ApiService();

  static suggestTopic(
    BuildContext context,
    WidgetRef ref, {
    required String type,
    required String faculty,
    required String discipline,
    required String topic,
  }) {
    _apiService
        .apiRequest(context,
            loadingMessage: "Processing topic suggestion...",
            formData: {
              "type": type,
              type == "Professional Type" ? "division" : "faculty": faculty,
              type == "Professional Type" ? "sector" : "discipline": discipline,
              "topic": topic
            },
            url: Endpoints.RESEARCHER_SUGGEST_TOPIC,
            method: Methods.POST)
        .then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(
          context,
          title: value.message,
          description: "Topic suggestion successful",
        );

        Future.delayed(const Duration(seconds: 1), () {
          ref.watch(selectedDrawerProvider.notifier).setState(0);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AllNavScreens.allNavScreens,
            (_) => false,
          );
        });
      }
    });
  }

  static likeAndUnlikeTopic(BuildContext context, {required String topicId}) {
    _apiService
        .apiRequest(context,
            showLoading: false,
            formData: {},
            url: Endpoints.LIKE_AND_UNLIKE_TOPIC(topicId),
            method: Methods.POST)
        .then((value) {});
  }

  // static Future<ResponseStatus> getTopics(BuildContext context) async {
  //   late TopicsList bankList;
  //   await _apiService
  //       .apiRequest(context,
  //           url: Endpoints.FETCH_TOPICS,
  //           method: Methods.GET,
  //           loadingMessage: "Fetching available banks...")
  //       .then((value) {
  //     if (value.status == true) {
  //       List<dynamic> rawBanks = value.data;
  //       bankList = rawBanks.map((e) => BankModel.fromJson(e)).toList();
  //     }
  //   });

  //   return bankList;
  // }
}
