/// ============================[BASICALLY DEFINES PATHS TO IMAGE FOLDER]
enum ImagePath { usual, svg, icon, gif }

/// ============================[IMAGE COOCKER]
String image(
  String imageName, {
  ImagePath imagePath = ImagePath.usual,
}) {
  /// ============================[DETERMINES PATH TO IMAGE FOLDER]
  String folderName = switch (imagePath) {
    ImagePath.svg => "svgs",
    ImagePath.icon => "icons",
    ImagePath.gif => "gifs",
    _ => "images"
  };
  return 'assets/$folderName/$imageName.${folderName.contains("svg") ? "svg" : folderName.contains("gif") ? "gif" : "png"}';
}

/// ============================[CLASS OF ALL IMAGES]
class ImageOf {
  /// =====================================[App Logo]========================
  /// =====================================[App Logo]========================
  /// =====================================[App Logo]========================
  static String logo = image("logo");
  static String logoRound = image("logo_round");
  static String logoWideOne = image("logo_wide_one", imagePath: ImagePath.svg);

  /// =====================================[Intro screens]========================
  /// =====================================[Intro screens]========================
  /// =====================================[Intro screens]========================
  static String slidie1 = image("intro_slide1", imagePath: ImagePath.svg);
  static String slidie2 = image("intro_slide2", imagePath: ImagePath.svg);
  static String slidie3 = image("intro_slide3", imagePath: ImagePath.svg);

  /// =====================================[Intro screens]========================
  /// =====================================[Intro screens]========================
  /// =====================================[Intro screens]========================
  static String walletSlider1 =
      image("wallet_slider1", imagePath: ImagePath.svg);
  static String walletSlider2 =
      image("wallet_slider2", imagePath: ImagePath.svg);
  static String walletSlider3 =
      image("wallet_slider3", imagePath: ImagePath.svg);
  static String walletSlider4 =
      image("wallet_slider4", imagePath: ImagePath.svg);

  /// ===================================== [USER TYPES => Client OR Researcher]
  /// ===================================== [USER TYPES => Client OR Researcher]
  /// ===================================== [USER TYPES => Client OR Researcher]
  static String client = image("user_client", imagePath: ImagePath.svg);
  static String researcher = image("user_researcher", imagePath: ImagePath.svg);

  /// =====================================[In-App Icons]========================
  /// =====================================[In-App Icons]========================
  /// =====================================[In-App Icons]========================
  static String visibilityEye = image("visibility", imagePath: ImagePath.icon);
  static String backIcon = image("back_icon", imagePath: ImagePath.icon);
  static String copyIcon = image("copy_icon", imagePath: ImagePath.icon);
  static String filerIcon = image("filer_icon", imagePath: ImagePath.icon);
  static String searchIcon = image("search_icon", imagePath: ImagePath.icon);
  static String mergeIcon = image("merge_icon", imagePath: ImagePath.icon);
  static String profileIconn = image("profile_icon", imagePath: ImagePath.icon);
  static String profileIconn2 =
      image("profile_icon2", imagePath: ImagePath.icon);
  static String myJobIcon = image("my_job_icon", imagePath: ImagePath.icon);
  static String editIconn = image("edit_icon", imagePath: ImagePath.icon);
  static String creditCardIcon =
      image("credit_card", imagePath: ImagePath.icon);
  static String bankIcon = image("bank_icon", imagePath: ImagePath.icon);
  static String lockIcon = image("lock_icon", imagePath: ImagePath.icon);
  static String fileAttachmnentIcon =
      image("file_attachmnent_icon", imagePath: ImagePath.icon);
  static String selectedIcon =
      image("selected_icon", imagePath: ImagePath.icon);
  static String unselectedIcon =
      image("unselected_icon", imagePath: ImagePath.icon);
  static String locationIcon =
      image("location_icon", imagePath: ImagePath.icon);
  static String areaOfExperienceIcon =
      image("area_of_experience_icon", imagePath: ImagePath.icon);
  static String yearsOfExperience =
      image("years_of_experience", imagePath: ImagePath.icon);
  static String stariconoutlined =
      image("star_icon_outlined", imagePath: ImagePath.icon);
      static String chatAttachment =
      image("chat_attachment", imagePath: ImagePath.icon);
      static String chatDownload =
      image("chat_download", imagePath: ImagePath.icon);
  static String declinerateicon =
      image("decline_rate_icon", imagePath: ImagePath.icon);
  static String deliveryRateIcon =
      image("delivery_rate_icon", imagePath: ImagePath.icon);
  static String downloadIcon =
      image("download_icon", imagePath: ImagePath.icon);
  static String messageAvailable =
      image("message_available", imagePath: ImagePath.icon);
  static String shareIcon = image("share_icon", imagePath: ImagePath.icon);
  static String genefratePaymentIcon =
      image("genefrate_payment_icon", imagePath: ImagePath.icon);
  static String bell = image("bell", imagePath: ImagePath.icon);
  static String pdfFile = image("pdf_file", imagePath: ImagePath.icon);
  static String docFile = image("doc_file", imagePath: ImagePath.icon);
  static String verified = image("verified", imagePath: ImagePath.icon);
  static String verified2 = image("verified2", imagePath: ImagePath.icon);
  static String ratedIcon = image("rated_icon", imagePath: ImagePath.icon);
  static String ashStar = image("ash_star", imagePath: ImagePath.icon);
  static String withdrwIcon = image("withdrw_icon", imagePath: ImagePath.icon);
  static String noSearchLight =
      image("no_search_light", imagePath: ImagePath.icon);
  static String noSearchDark =
      image("no_search_dark", imagePath: ImagePath.icon);
  static String indeedJobIcon =
      image("indeed_job_icon", imagePath: ImagePath.icon);
      static String editWorkIcon =
      image("edit_work_icon", imagePath: ImagePath.icon);
  static String facebook = image("facebook", imagePath: ImagePath.svg);
  static String x = image("x", imagePath: ImagePath.svg);
  static String instagram = image("instagram", imagePath: ImagePath.svg);
  static String linkedin = image("linkedin", imagePath: ImagePath.svg);

  /// =====================================[In-App Images]========================
  /// =====================================[In-App Images]========================
  /// =====================================[In-App Images]========================
  static String publication = image("publication_card");
  static String markDone = image("mark_done", imagePath: ImagePath.svg);
  static String walletIllustration =
      image("wallet_illustration", imagePath: ImagePath.svg);
  static String emailSent = image("email_sent", imagePath: ImagePath.svg);
  static String emptyProfilePic =
      image("empty_profile_pic", imagePath: ImagePath.svg);
  static String noResult = image("no_result", imagePath: ImagePath.svg);
  static String deleteNotification =
      image("delete_notification", imagePath: ImagePath.svg);

  /// =====================================[In-App GIFS]========================
  /// =====================================[In-App GIFS]========================
  /// =====================================[In-App GIFS]========================
  static String successGif = image("success_gif", imagePath: ImagePath.gif);
  static String cancelGif = image("cancel_gif", imagePath: ImagePath.gif);
  static String loadingGif = image("loading_gif", imagePath: ImagePath.gif);

  /// ===================================== [Request status]
  static String emptyRequest = image("empty", imagePath: ImagePath.svg);

  /// =====================================[Nav Icons]========================
  /// =====================================[Nav Icons]========================
  /// =====================================[Nav Icons]========================
  static String homeNav = image("nav_home", imagePath: ImagePath.icon);
  static String messageNav = image("nav_message", imagePath: ImagePath.icon);
  static String notificationNav =
      image("nav_notification", imagePath: ImagePath.icon);
  static String onNavHome = image("on_nav_home", imagePath: ImagePath.icon);
  static String onNavMessage =
      image("on_nav_message", imagePath: ImagePath.icon);
  static String onNavNotification =
      image("on_nav_notification", imagePath: ImagePath.icon);
  static String floatingActionButton =
      image("floating_action_button", imagePath: ImagePath.svg);

  /// =====================================[Sample Users] =======================
  /// =====================================[Sample Users] =======================
  /// =====================================[Sample Users] =======================
  static String profilePic1 = image("profile_pics");
  static String profilePic2 = image("profile_pics2");
  static String profilePic3 = image("profile_pics3");
  static String profilePic4 = image("profile_pics4");
}
