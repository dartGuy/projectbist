// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project_bist/CORE/app_objects.dart';
// import 'package:project_bist/PROVIDERS/transaction_providers/transajmction_providers/transaction_providers.dart';

// final topicsSortProvider =
//     StateNotifierProvider<TopicsSortProvider, TopicsSortAndSearch>(
//         (ref) => TopicsSortProvider());

// class TopicsSortProvider extends StateNotifier<TopicsSortAndSearch> {
//   TopicsSortProvider()
//       : super(TopicsSortAndSearch(topicList: [], searchTopicsList: []));

//   getBanksList(BuildContext context) {
//     TransactionsProvider.getBanks(context).then((value) {
//       state.topicList = value;
//       state.searchTopicsList = value;
//     });
//   }

//   searchBanks({String? searchQuery}) {
//     state.searchTopicsList = state.topicList
//         .where((element) => element.name
//             .toLowerCase()
//             .contains((searchQuery ?? "").toLowerCase()))
//         .toList();
//   }
// }

// class TopicsSortAndSearch {
//   BankList topicList;
//   BankList searchTopicsList;

//   TopicsSortAndSearch({required this.topicList, required this.searchTopicsList});
// }
