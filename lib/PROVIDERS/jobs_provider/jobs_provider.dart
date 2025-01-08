import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/MODELS/job_model/reseracher_job_model.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/SERVICES/api_respnse.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/color_themes.dart';

final userJobsProvider =
    StateNotifierProvider<BaseProvider<JobModel>, ResponseStatus>(
        (ref) => BaseProvider<JobModel>());

final researcherJobsProvider =
    StateNotifierProvider<BaseProvider<ResearcherJobModel>, ResponseStatus>(
        (ref) => BaseProvider<ResearcherJobModel>());

class JobsProvider {
  static final ApiService _apiService = ApiService();
  static clientPostJob(BuildContext context, WidgetRef ref,
      {required JobModel jobModel, required bool isFixedBudget}) {
    ref
        .read(userJobsProvider.notifier)
        .makeRequest(
          context: context,
          url: Endpoints.CLIENTS_POSTED_JOBS_FETCH,
          method: Methods.POST,
          formData: jobModel.toJson(ref: ref, isFixedBudget: isFixedBudget),
          loadingPostRequestMessage: "Posting your job...",
        )
        .then((value) {
      if (value.status == true) {
        ref.invalidate(userJobsProvider);
        Alerts.openStatusDialog(context,
            isSuccess: true, description: value.message, isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(5, (index) => Navigator.pop(context));
        });
      }
    });
  }

  static Future<ApiResponse> clientDeactivateJobApplication(
      BuildContext context, WidgetRef ref,
      {required String jobId}) async {
    return await ref
        .read(userJobsProvider.notifier)
        .makeRequest(
            context: context,
            url: Endpoints.CLIENT_DEACTIVATE_JOB_APPLICATION(jobId),
            method: Methods.PATCH,
            formData: {},
            loadingPostRequestMessage:
                "Deactivating application for this job...")
        .then((value) async {
      if (value.status == true) {
        ref.invalidate(userJobsProvider);
        Alerts.openStatusDialog(context, description: value.message);
        await Future.delayed(const Duration(seconds: 3), () {
          List.generate(2, (index) => Navigator.pop(context));
        });
      }
      return value;
    });
  }

  static Future<ApiResponse> researcherApplyForJob(
      BuildContext context, WidgetRef ref,
      {required String jobId}) async {
    return await ref
        .read(researcherJobsProvider.notifier)
        .makeRequest(
          context: context,
          url: Endpoints.RESEARCHER_APPLY_FOR_JOB(jobId),
          method: Methods.POST,
          formData: {},
          loadingPostRequestMessage:
              "Processing your application for this job...",
        )
        .then((value) async {
      if (value.status == true) {
        ref.invalidate(researcherJobsProvider);
        ref.invalidate(researcherAppliedJobsProvider);
        Alerts.openDialog(context,
            title: "Job application successful",
            subtitle: "The job owner should get back to you soon");
        await Future.delayed(const Duration(seconds: 3), () {
          List.generate(3, (index) => Navigator.pop(context));
        });
      }
      return value;
    });
  }

  static researcherWithdrawApplication(BuildContext context, WidgetRef ref,
      {required String jobId}) async {
    await Alerts.optionalDialog(context,
        text:
            "Are you sure you want to withdraw your application for this job?",
        right: "No, cancel",
        left: "Yes, withdraw",
        leftColor: AppColors.red, onTapLeft: () async {
      Navigator.pop(context);
      await ref
          .read(researcherAppliedJobsProvider.notifier)
          .makeRequest(
            context: context,
            url: Endpoints.RESEARCHER_WITHDRAW_APPLICATION(jobId),
            method: Methods.DELETE,
            formData: {},
            loadingPostRequestMessage:
                "Withdrawing your application for this job...",
          )
          .then((value) async {
        if (value.status == true) {
          ref.invalidate(researcherJobsProvider);
          ref.invalidate(researcherAppliedJobsProvider);

          Alerts.openDialog(context,
              title: "Withdrawal successful",
              subtitle: "Application withdrawal successful");
          await Future.delayed(const Duration(seconds: 3), () {
            List.generate(3, (index) => Navigator.pop(context));
          });
        }
        return value;
      });
    });
  }

  static clientDeleteJob(BuildContext context, WidgetRef ref,
      {required String jobId}) {
    Navigator.pop(context);
    _apiService
        .apiRequest(context,
            url: Endpoints.CLIENT_DELETE_JOB(jobId),
            method: Methods.DELETE,
            loadingMessage: "Deleting this job...")
        .then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            description: "Job deleted successfully", isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          ref.invalidate(userJobsProvider);
        });
      }
    });
  }
}
