import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/publication_models/bought_publiction.dart';
import 'package:project_bist/MODELS/publication_models/publication_draft.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/SERVICES/api_respnse.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/methods.dart';
import "package:project_bist/UTILS/constants.dart";

final publicationsProvider =
    StateNotifierProvider<BaseProvider<PublicationModel>, ResponseStatus>(
        (ref) => BaseProvider<PublicationModel>());

final generalPublicationsProvider =
    StateNotifierProvider<BaseProvider<PublicationModel>, ResponseStatus>(
        (ref) => BaseProvider<PublicationModel>());

final buyPublicationsProvider =
    StateNotifierProvider<BaseProvider<BoughPublications>, ResponseStatus>(
        (ref) => BaseProvider<BoughPublications>());

final likePublicationsProvider =
    StateNotifierProvider<BaseProvider<int>, ResponseStatus>(
        (ref) => BaseProvider<int>());

class PublicationsAndPlagiarismCheckProvider {
  static final ApiService _apiService = ApiService();
  static final ApiService _cloudinaryApiService =
      ApiService(hasBearerToken: false);

  static researcherCreatePublication(BuildContext context,
      {required String title,
      required String paperType,
      required String abstractText,
      required String attachmentFile,
      required List<String> paperTags,
      required List<String> owners,
      required int numOfRef,
      required int price,
      required WidgetRef ref}) {
    if (abstractText.isEmpty || paperType.isEmpty || title.isEmpty) {
      Alerts.openStatusDialog(context,
          isSuccess: false, description: "Some fields are missing");
    } else {
      ref
          .watch(publicationsProvider.notifier)
          .makeRequest(
              context: context,
              url: Endpoints.CREATE_PUBLICATION,
              method: Methods.POST,
              formData: {
                "title": title,
                "type": paperType,
                "abstract": abstractText,
                "attachment": attachmentFile, //public id from cloudinary
                "tags": paperTags,
                "owners": owners,
                "numOfRef": numOfRef,
                "price": price,
                "currency": "NGN"
              },
              //
              loadingPostRequestMessage: "Publishing your paper...")
          .then((value) {
        if (value.status == true) {
          ref.invalidate(publicationsProvider);
          Alerts.openStatusDialog(context,
              description: AppMethods.toTitleCase(value.message));
          Future.delayed(const Duration(seconds: 2), () {
            List.generate(3, (index) {
              return Navigator.pop(context);
            });
          });
        }
      });
    }
  }

  static Future<ApiResponse> likeAndUnlikePublication(
      BuildContext context, WidgetRef ref,
      {required String publicationId}) {
    return ref.read(likePublicationsProvider.notifier).makeRequest(
      showAlerts: false,
      context: context,
      url: Endpoints.LIKE_AND_UNLIKE_PUBLICATION(publicationId),
      method: Methods.POST,
      formData: {},
    ).then((value) {
      if (value.status == true) {
        ref.invalidate(publicationsProvider);
      }
      return value;
    });
    // _apiService
    //     .apiRequest(context,
    //         showLoading: false,
    //         formData: {},
    //         url: Endpoints.LIKE_AND_UNLIKE_PUBLICATION(publicationId),
    //         method: Methods.POST)
    //     .then((value) {});
  }

  static purchasePublication(BuildContext context,
      {required String publicationId}) {
    bool? status;
    _apiService
        .apiRequest(
      context,
      url: Endpoints.PURCHASE_PUBLICATION(publicationId),
      loadingMessage: "Purchasing publication...",
      formData: {},
      method: Methods.POST,
    )
        .then((value) {
      status = value.status;
    });

    return status;
  }

  static aiContentCheck(BuildContext context, {required String text}) {
    _apiService.apiRequest(context,
        url: Endpoints.AI_CONTENT_CHECK,
        loadingMessage: "Determining AI content in text...",
        method: Methods.POST,
        formData: {"text": text}).then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            description: AppMethods.toTitleCase(value.message));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    });
  }

  static plagiarismCheck(BuildContext context,
      {required String uploadedFileURL}) {
    _apiService.apiRequest(context,
        url: Endpoints.SUBMIT_DOCUMENT_PLAGIARISM,
        loadingMessage: "Scanning document text...",
        method: Methods.POST,
        formData: {"attachment": uploadedFileURL}).then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            description: AppMethods.toTitleCase(value.message));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    });
  }

  static Future<String> uploadFIleToCloudinary(BuildContext context,
      {required String filePath}) async {
    String documentUrl = "";
    await _cloudinaryApiService.apiRequest(context,
        url: Endpoints.CLOUDINARY_API(AppConst.CLOUDINARY_CLOUD_NAME),
        dataKey: "url",
        loadingMessage: "Processing submitted document...",
        method: Methods.POST,
        formData: {
          //         String filePath, {
          // String? filename,
          // MediaType? contentType,
          // final Map<String, List<String>>? headers,
          "upload_preset": AppConst.CLOUDINARY_UPLOAD_PRESET,
          "file": await MultipartFile.fromFile(filePath,
              filename: filePath.split("/").last)
        }).then((value) {
      if (value.status == true) {
        documentUrl = value.data;
      }
    });
    print("value.data===: $documentUrl");
    return documentUrl;
  }

  //PublicationDraft
  //Box<PublicationDraft>
  static addToDraft(BuildContext context,
      {required Box<PublicationDraft> box,
      required PublicationDraft publicationDraft}) {
    if (publicationDraft.abstractText.isEmpty ||
        publicationDraft.price.toString().isEmpty ||
        publicationDraft.tags.isEmpty ||
        publicationDraft.title.isEmpty) {
      Alerts.openStatusDialog(context);
    } else if (box.values
        .toList()
        .where((e) => e.title == publicationDraft.title)
        .toList()
        .isNotEmpty) {
      Alerts.openStatusDialog(context,
          isSuccess: false,
          description:
              "Publication with title \"${publicationDraft.title}\" already exist");
    } else {
      Alerts.showLoading(context,
          loadingMessage: "Saving publication to draft");
      Future.delayed(const Duration(milliseconds: 2500), () {
        box.add(publicationDraft);
        BotToast.cleanAll();
        Alerts.openStatusDialog(context,
            isSuccess: true, description: "Publication saved to draft");
        List.generate(2, (index) => Navigator.pop(context));
      });
    }
  }

  static deletePublication(BuildContext context,
      {required String publicationId, required WidgetRef ref}) {
    ref
        .watch(publicationsProvider.notifier)
        .makeRequest(
          context: context,
          url: Endpoints.DELETE_PUBLICATION(publicationId),
          method: Methods.DELETE,
          formData: {},
          loadingPostRequestMessage: "Deleting your publication...",
        )
        .then((value) {
      if (value.status == true) {
        ref.invalidate(publicationsProvider);
        Alerts.openStatusDialog(context,
            description: AppMethods.toTitleCase(value.message));
      }
    });
  }
}

class AttachmentFile {
  final String filePath, fileName;
  AttachmentFile({required this.fileName, required this.filePath});
}
