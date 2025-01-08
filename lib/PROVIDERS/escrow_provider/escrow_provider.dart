import 'package:flutter/material.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import "package:project_bist/VIEWS/wallet_processes/wallet_home.dart";
import "package:project_bist/UTILS/constants.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';

import '../../CORE/app_models.dart';
import '../../main.dart';

final escrowsProvider = StateNotifierProvider<BaseProvider<EscrowWithSubmissionPlanModel>, ResponseStatus>((ref) => BaseProvider<EscrowWithSubmissionPlanModel>());

final escrowsJobsAppliedByResearcherProvider = StateNotifierProvider<BaseProvider<List<String>>, ResponseStatus>((ref) => BaseProvider<List<String>>());

final researcherAppliedJobsProvider = StateNotifierProvider<BaseProvider<EscrowWithSubmissionPlanModel>, ResponseStatus>((ref) => BaseProvider<EscrowWithSubmissionPlanModel>());

ApiService apiService = ApiService();

class EscrowProvider {
static int exitCount  = 0;

  static createEscrowFromResearchersProfile(BuildContext context, {required WidgetRef ref, required String researcherId, required String jobId, required String projectFee, required UserProfile userProfile}) {
    ref
        .watch(escrowsProvider.notifier)
        .makeRequest(
          context: context,
          url: Endpoints.CREATE_ESCROW_FROM_RESEARCHERS_PROFILE(
            researcherId: researcherId,
            jobId: jobId,
            projectFee: projectFee,
          ),
          method: Methods.POST,
          formData: {},
          loadingPostRequestMessage: "Creating your escrow...",
        )
        .then((value) {
      if (value.status == true) {
        ref.invalidate(escrowsProvider);
        ref.invalidate(userJobsProvider);
        Alerts.openStatusDialog(context, description: "Escrow created successfully", isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(5, (_) => Navigator.pop(context));
        });

        // Navigator.pushReplacementNamed(
        //     context,
        //     ClientViewResearchersProfileScreen
        //         .clientViewResearchersProfileScreen,
        //     arguments: ClientViewResearchersProfileScreenArgument(
        //         escrowModel: EscrowModel.fromJson(json: value.data),
        //         userProfile: userProfile));
      } else if (value.message.toLowerCase() == AppConst.ESCROW_CREATION_FAILED_ERROR.toLowerCase()) {
        Alerts.optionalDialog(context, text: value.message, left: "Fund wallet", title: "Request failed", onTapLeft: () {
          Navigator.pushNamed(context, WalletHomePage.walletHomePage);
        }, right: "No, Later");
      }
    });
  }

  static createEscrowAsYouGoo(BuildContext context, {required WidgetRef ref, required String researcherId, required UserProfile userProfile, required JobModel jobModel, required bool isFixedBudget}) {
    ref
        .watch(escrowsProvider.notifier)
        .makeRequest(
          context: context,
          url: Endpoints.CREATE_ESCROW_AS_YOU_GOO(
            researcherId: researcherId,
          ),
          method: Methods.POST,
          formData: jobModel.toJson(ref: ref, isFixedBudget: isFixedBudget, isProjectFee: true),
          loadingPostRequestMessage: "Creating your escrow...",
        )
        .then((value) {
      if (value.status == true) {
        ref.invalidate(escrowsProvider);
        ref.invalidate(userJobsProvider);
        Alerts.openStatusDialog(context, description: "Escrow created successfully", isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(5, (_) => Navigator.pop(context));
        });
        // Navigator.pushReplacementNamed(
        //     context,
        //     ClientViewResearchersProfileScreen
        //         .clientViewResearchersProfileScreen,
        //     arguments: ClientViewResearchersProfileScreenArgument(
        //         escrowModel: EscrowModel.fromJson(json: value.data),
        //         userProfile: userProfile));
      }
    });
  }

  static fundEscrow(BuildContext context, WidgetRef ref, {required String escrowId, required int amount}) {
    apiService.apiRequest(context, url: Endpoints.FUND_ESCROW(escrowId: escrowId, amount: amount), loadingMessage: "Funding your escrow...", formData: {}, method: Methods.PATCH).then((value) {
      if (value.status == true) {
        getIt<AppModel>().appCacheBox!.put(AppConst.USER_ESCROW_BALANCE, getIt<AppModel>().appCacheBox!.get(AppConst.USER_ESCROW_BALANCE) + amount);
        ref.invalidate(escrowsProvider);
        ref.invalidate(transactionProvider);
        ref.invalidate(researcherAppliedJobsProvider);
        Alerts.openStatusDialog(context, description: "Escrow funded successfully", isSuccess: true, isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(2, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static deleteEscrow(BuildContext context, WidgetRef ref, {required String escrowId}) {
    ref.watch(escrowsProvider.notifier).makeRequest(
      context: context,
      url: Endpoints.DELETE_ESCROW(escrowId),
      loadingPostRequestMessage: "Deleting escrow...",
      method: Methods.DELETE,
      formData: {},
    ).then((value) {
      if (value.status == true) {
        ref.invalidate(escrowsProvider);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(2, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static addSubmissionPlan(BuildContext context, WidgetRef ref, {required String escrowId, required String name, required String deliverables, required String deadline, required int price}) {
    apiService
        .apiRequest(context,
            url: Endpoints.ADD_SUBMISSION_PLAN(escrowId),
            loadingMessage: "Adding your submission plan...",
            formData: {
              "name": name,
              "deliverable": deliverables,
              "deadline": deadline,
              "price": price,
            },
            method: Methods.POST)
        .then((value) {
      if (value.status == true) {
        ref.invalidate(escrowsProvider);
        Alerts.openStatusDialog(context, description: "Successfully added submission plan for this escrow", isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(4, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static Future<int> approveSubmissionPlan(BuildContext context, WidgetRef ref, {required String planId, required String batchTitle}) async{
    Alerts.optionalDialog(context, title: "Confirm Approval", text: "Are you sure you want to approve this batch submission?", left: "Approve", onTapLeft: () {
      Navigator.pop(context);
      apiService.apiRequest(context, url: Endpoints.APPROVE_SUBMISSION_PLAN(planId), formData: {}, loadingMessage: "Approving your submission plan...", method: Methods.PATCH).then((value) {
        if (value.status == true) {
          ref.invalidate(escrowsProvider);
          Alerts.openStatusDialog(context, title: "Batch Approved", subtitle: RichText(text: TextSpan(style: TextStyle(fontSize: 14.sp, color: AppThemeNotifier.colorScheme(context).primary), text: "You have approved your researcher’s submission of ", children: [TextSpan(text: batchTitle, style: const TextStyle(fontWeight: FontWeight.w500))])), isDismissible: false);
          Future.delayed(const Duration(seconds: 2), () {
            List.generate(4, (_) {
            exitCount ++;
                Navigator.pop(context)
           ; }

            );
          });
        }
      });
    }, right: "No, Cancel", leftColor: AppColors.primaryColor, rightColor: AppColors.brown);
    return exitCount;
  }

  static Future requestForReviewOfSubmissionPlan(BuildContext context, WidgetRef ref, {required String planId, required int duration, required String durationType}) async {
    Navigator.pop(context);
    await apiService.apiRequest(context, url: Endpoints.REQUEST_FOR_REVIEW_OF_SUBMISSION_PLAN(planId: planId), loadingMessage: "Requesting for review of your submission plan...", formData: {"duration": duration, "durationType": durationType}, method: Methods.PATCH).then((value) {
      if (value.status == true) {
        ref.invalidate(escrowsProvider);
        Alerts.openStatusDialog(context, description: "Successfully requested for review of this submission plan", isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(4, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static clientReviewResearcher(BuildContext context, WidgetRef ref, {required String researcherId, required int rating, required String review}) {
    // Navigator.pop(context);
    apiService.apiRequest(context, url: Endpoints.CLIENT_REVIEW_RESEARCHER(researcherId), loadingMessage: "Sending your review of this researcher...", formData: {"review": review, "rating": rating}, method: Methods.POST).then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context, description: "Successfully sent your review of this researcher", isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(3, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static clientCompleteEscrowJob(BuildContext context, WidgetRef ref, {required String escrowId}) {
    // Navigator.pop(context);
    apiService.apiRequest(context, url: Endpoints.CLIENT_COMPLETE_ESCROW_JOB(escrowId), loadingMessage: "Request to mark this escrow as complete in progress...", formData: {}, method: Methods.POST).then((value) {
      if (value.status == true) {
        ref.invalidate(escrowsProvider);
        if(context.mounted){
        Alerts.openStatusDialog(context, description: "Successfully marked this escrow job as completed", isDismissible: false);
        }
        Future.delayed(const Duration(seconds: 2), () {
          List.generate(3, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static researcherSubmitDocumentForSubmissionPlan(BuildContext context, WidgetRef ref, {required String planId, required String attachment, required String batchName}) {
    apiService.apiRequest(context, url: Endpoints.RESEARCHER_SUBMIT_SUBMISSION_PLAN_ATTACHMENT(planId), loadingMessage: "Submitting batch submission attachment...", formData: {"attachment": attachment}, method: Methods.PATCH).then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            title: "Batch submitted",
            isDismissible: false,
            subtitle: RichText(
                text: TextSpan(style: TextStyle(fontSize: 14.sp, color: AppThemeNotifier.colorScheme(context).primary), text: "Your file for ", children: [
              TextSpan(text: batchName, style: const TextStyle(fontWeight: FontWeight.w500), children: const [TextSpan(style: TextStyle(fontWeight: FontWeight.w400), text: " has been submitted and pending approval.")])
            ])));
        Future.delayed(const Duration(seconds: 2), () {
          ref.invalidate(escrowsProvider);
          List.generate(4, (_) => Navigator.pop(context));
        });
      }
    });
  }

  static clientPauseEscrowJob(BuildContext context, WidgetRef ref, {required String jobId, required String pauseDeadline, required String pauseReason}) {
    Alerts.optionalDialog(context, text: "Are you sure you want to pause this escrow job?", left: "Pause", title: "Confirm Pause Request", onTapLeft: () {
      Navigator.pop(context);
      apiService.apiRequest(context, url: Endpoints.CLIENT_PAUSE_ESCROW_JOB(jobId), formData: {"pauseDeadline": pauseDeadline, "reason": pauseReason}, loadingMessage: "Pausing escrow job...", method: Methods.PATCH).then((value) {
        if (value.status == true) {
          ref.invalidate(escrowsProvider);
          ref.invalidate(userJobsProvider);
          Alerts.openStatusDialog(context, description: "Your request to “Pause/Resume your job” has been submitted successfully. We will get back to you as soon as possible.", isDismissible: false);
          Future.delayed(const Duration(seconds: 2), () {
            List.generate(5, (index) => Navigator.pop(context));
          });
        }
      });
    }, right: "No, Cancel");
  }

  static declineSubmissionPlan(BuildContext context, WidgetRef ref, {required String planId}) {
    Alerts.optionalDialog(context, text: "Even by declining, a 10% Escrow maintenance fee will be deducted. The balance will be added to your wallet.\nAre you sure you want to decline this batch submission?", left: "Decline", title: "Confirm Declination", onTapLeft: () {
      Navigator.pop(context);
      apiService.apiRequest(context, url: Endpoints.DECLINE_SUBMISSION_PLAN(planId), formData: {}, loadingMessage: "Declining submission plan...", method: Methods.PATCH).then((value) {
        if (value.status == true) {
          ref.invalidate(escrowsProvider);
          Alerts.openStatusDialog(context, description: "Submission plan declined successfully", isDismissible: false);
          Future.delayed(const Duration(seconds: 2), () {
            List.generate(5, (index) => Navigator.pop(context));
          });
        }
      });
    }, right: "No, Cancel");
  }
}