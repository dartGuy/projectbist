import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/activity_preview.dart';

class PersistenceProvider<Data> extends StateNotifier<Data> {
  PersistenceProvider(super.initialState);

  void setData(Data value) {
    state = value;
  }
}

class PersistDataProvider {
  static final availableSubmissionPlans =
      StateNotifierProvider<PersistenceProvider<List<EscrowActivities>>, List<EscrowActivities>>(
          (ref) => PersistenceProvider<List<EscrowActivities>>([]));
}
