import 'dart:io';
import 'package:dio/dio.dart';
import "package:path_provider/path_provider.dart" as pth;
export 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/core.dart';
export 'package:image_picker/image_picker.dart';
import "package:project_bist/main.dart";
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppMethods<Item extends Object> {
  static bool isEmailValid(email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static String toTitleCase(String input) {
    if (input.isEmpty) {
      return input;
    }
    List<String> words = input.toLowerCase().split(' ');
    List<String> titleCaseWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1)).toList();
    String titleCaseString = titleCaseWords.join(' ');

    return titleCaseString;
  }

  static Future<File?> pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: imageSource);
    if (xfile == null) {
      return null;
    } else {
      return File(xfile.path);
    }
  }

  static bool getUserHasSeenOnboardingScreens() {
    bool status = (getIt<AppModel>()
            .appCacheBox!
            .get(AppConst.HAS_SEEN_ONBOARDING_SCREENS) ??
        false);
    return status;
  }

  static bool getRecognizedUser() {
    String userToken =
        getIt<AppModel>().appCacheBox!.get(AppConst.TOKEN_KEY) ?? "";
    bool status = userToken.isNotEmpty;
    return status;
  }

  static String moneyComma(moneyNumber) {
    List<String> chunks =
        moneyNumber.toString().split("").toList().reversed.toList();
    List<String> money = [];
    for (int i = 0; i < chunks.length; i++) {
      money.add((i) % 3 == 0 ? "${chunks[i]}," : chunks[i]);
    }
    if (moneyNumber.toString().length > 3) {
      if (money.reversed
              .toList()
              .join()
              .split("")
              .toList()[money.reversed.toList().join().length - 1] ==
          ",") {
        return money.reversed
            .toList()
            .join()
            .substring(0, money.reversed.toList().join().length - 1);
      } else {
        return money.reversed.toList().join();
      }
    } else {
      return moneyNumber.toString();
    }
  }

  static downloadFile(
      {required String url,
      required String fileName,
      Function(String?, double)? onProgress,
      Function(String)? onDownloadCompleted,
      Function(String)? onDownloadError}) {
    FileDownloader.downloadFile(
      url: url,
      name: fileName,
      notificationType: NotificationType.all,
      onProgress: onProgress,
      onDownloadCompleted: onDownloadCompleted,
      onDownloadError: onDownloadError,
    );
  }

  static bool isBackendVerifiedUser() {
    return (getIt<AppModel>()
                .appCacheBox!
                .get(AppConst.BACKEND_VERIFIED_USER) ??
            false) ==
        true;
  }

  static bool hasSeenWalletFlow() {
    return (getIt<AppModel>().appCacheBox!.get(AppConst.HAS_SEEN_WALLET_FLOW) ??
            false) ==
        true;
  }

  static void invalidateProviders({required WidgetRef ref}) {
    for (StateNotifierProvider e in providersToDispose) {
      ref.invalidate(e);
    }
  }

  List<Item> paginateList(
      {required int paginationNo, required List<Item> itemList}) {
    List<Item> item = [];

    for (int i = 0; i < paginationNo; i++) {
      if (itemList.length < paginationNo) break;
      item.add(itemList[i]);
    }

    return item;
  }

  static String convertStringToDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("yyyy/MM/dd");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

    DateTime dateTime = inputFormat.parse(inputDate);
    String formattedDate = outputFormat.format(dateTime.toUtc());

    return formattedDate;
  }

  static bool isDateInRange(
      {required String inputDateStr,
      required String startDateStr,
      required String endDateStr}) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime inputDate = dateFormat.parse(inputDateStr);
    DateTime startDate = dateFormat.parse(startDateStr);
    DateTime endDate = dateFormat.parse(endDateStr);
    return inputDate.isAfter(startDate) && !inputDate.isAfter(endDate);
  }

  static handleMessageComeInDate(DateTime dateTime) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    if (dateTime.isAfter(todayStart)) {
      return DateFormat.jm().format(dateTime);
    } else if (dateTime.isAfter(yesterdayStart)) {
      return 'Yesterday';
    } else {
      return timeago.format(dateTime);
    }
  }

  static Future loadProjectBistFiles() async {
    Directory rootDirectory = await pth.getApplicationDocumentsDirectory();
    // String rootDir = (rootDirectory?.path) ?? "";
    // if (Platform.isAndroid) {
    //   int i = rootDir.indexOf("data");
    //   rootDir = "${rootDir.substring(0, i).replaceAll("data", "")}media";
    // }

    await for (FileSystemEntity entity
        in rootDirectory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        getIt<AppModel>()
            .projectBistFiles
            .add({entity.path.split('/').last: entity});
      }
    }

  }

  static bool isDownloaded(String fileNameCreatedDate) {
    bool val = (getIt<AppModel>().projectBistFiles.map((e) => e.keys.first))
        .isNotEmpty;
    return val;
  }

  /// [Download or open document in ProjectBist directory/mediaType => dir/(Photos/Videos/Documents)]
  static Future downloadAndOpenFile(String uri,
      {required ProgressCallback onReceiveProgress,
      required String attachmentName,
      required String createdAt,
      required String attachmentType}) async {
    // loadProjectBistFiles();
    Dio dio = Dio();
    Response response = await dio.get(uri,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: onReceiveProgress);
    Directory rootDirectory = await pth.getApplicationDocumentsDirectory();
    // String rootDir = (rootDirectory?.path) ?? "";
    // if (Platform.isAndroid) {
    //   int i = rootDir.indexOf("data");
    //   rootDir = "${rootDir.substring(0, i).replaceAll("data", "")}media";
    // }

    ///[This handles creation of media type "directory" if not exists]
    // Directory directoryOfAttachmentType = await Directory(
    //         "$rootDirectory/com.projectbist.app/ProjectBist/${switch (attachmentType) {
    //   "png" => "ProjectBist Images",
    //   "jpg" => "ProjectBist Images",
    //   "jpeg" => "ProjectBist Images",
    //   "mp4" => "ProjectBist Videos",
    //   _ => "ProjectBist Documents"
    // }}")
    //     .create(recursive: true);
    print(response.statusCode!);
    final File file = File(
        "${rootDirectory.path}/${attachmentName}_[PB]_$createdAt.$attachmentType");
    List<int> result = response.data!;
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(result);
    await raf.close();

    file.exists().then((value){
      if(value == true){
        OpenFile.open(file.path);
      }
    });

    // file.exists().then((value) {
    //   if (value == true) {
    //     file.open().then((value) {
    //       print('open 1');
    //     }, onError: (s) {});
    //   } else {
    //     file.writeAsBytes(result).then((value) {
    //       print('open 2');
    //       value.open();
    //     });
    //   }
    // });

    // loadProjectBistFiles();
  }
}