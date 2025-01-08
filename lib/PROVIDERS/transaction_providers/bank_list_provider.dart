import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';

final bankListProvider =
    StateNotifierProvider<BankListProvider, BandkListAndSearch>(
        (ref) => BankListProvider());

class BankListProvider extends StateNotifier<BandkListAndSearch> {
  BankListProvider()
      : super(BandkListAndSearch(bankList: [], searchBankList: []));

  getBanksList(BuildContext context) {
    TransactionsProvider.getBanks(context).then((value) {
      state.bankList = value;
      state.searchBankList = value;
    });
  }

  searchBanks({String? searchQuery}) {
    state.searchBankList = state.bankList
        .where((element) => element.name
            .toLowerCase()
            .contains((searchQuery ?? "").toLowerCase()))
        .toList();
  }
}

class BandkListAndSearch {
  BankList bankList;
  BankList searchBankList;

  BandkListAndSearch({required this.bankList, required this.searchBankList});
}
