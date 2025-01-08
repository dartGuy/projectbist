// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:async';
import 'dart:collection';

import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_bist/core.dart';

class WebViewPageArgument {
  String? sideDisplayUrl, loadingMessage;
  Function(String?)? whenSomeUrlConditionsMet;
  Function? onTryExit;
  WebViewPageArgument(
      {required this.sideDisplayUrl,
      this.onTryExit,
      this.whenSomeUrlConditionsMet,
      this.loadingMessage});
}

class WebViewPage extends ConsumerStatefulWidget {
  static const String webViewPage = "webViewPage";
  WebViewPageArgument? webViewPageArgument;

  WebViewPage({
    this.webViewPageArgument,
    super.key,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  late ContextMenu contextMenu;
  bool firstTime = true;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        // useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        transparentBackground: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        supportMultipleWindows: true,
        disableDefaultErrorPage: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  bool pageIsLoaded = false;
  double progress = 0;
  late PullToRefreshController pullToRefreshController;
  String siteUrl = AppConst.PRIVACY_POLICY_URL;

  String url = "";
  String downloadUrl = "";
  bool userCanGoBack = false;
  bool userCanGoForward = false;
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  ConnectivityResult _connectionResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription!.cancel();

    super.dispose();
  }

  int downloadProgress = 0;
  dynamic downloadId;
  String? downloadStatus;

  @override
  void initState() {
    BotToast.cleanAll();
    Future.delayed(const Duration(seconds: 2), () {
      Alerts.showLoading(context,
          loadingMessage: widget.webViewPageArgument!.loadingMessage!);
    });

    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
            androidId: 1,
            iosId: "1",
            title: "Special",
            action: () async {
              await webViewController?.clearFocus();
            })
      ],
      onHideContextMenu: () {},
      onContextMenuActionItemClicked: (contextMenuItemClicked) async {
        var id = contextMenuItemClicked.androidId;
        if (kDebugMode) {
          print(
              "onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        }
      },
      options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
      onCreateContextMenu: (hitTestResult) async {},
    );
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: AppColors.primaryColor,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    firstTime == true ? siteUrl : () {};
    firstTime = false;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Future.delayed(const Duration(seconds: 10), () {
      BotToast.cleanAll();
    });
    super.initState();
  }

  Future loadPage() async {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        pageIsLoaded = true;
      });
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionResult = result;
    });
  }

  bool canPop = true;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BotToast.cleanAll();
    });
    return (_connectionResult == ConnectivityResult.mobile ||
            _connectionResult == ConnectivityResult.wifi)
        ? PopScope(
            canPop: canPop,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: widget.webViewPageArgument?.onTryExit != null
                  ? AppBar(
                      backgroundColor: AppColors.primaryColor,
                      title:   TextOf("Complete payment", 14.sp, 5,color: AppColors.white),
                      centerTitle: true,
                      leading: InkWell(
                        onTap: () {
                          setState(() {
                            canPop = true;
                          });
                          ref.invalidate(transactionProvider);
                          widget.webViewPageArgument!.onTryExit!();
                          Navigator.pop(context);
                        },
                        child:
                            const IconOf(Icons.close, color: AppColors.white),
                      ),
                    )
                  : null,
              body: SafeArea(
                child: Column(children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: InAppWebView(
                                key: webViewKey,
                                initialUrlRequest: URLRequest(
                                    url: Uri.parse(widget.webViewPageArgument!.sideDisplayUrl!)),
                                initialOptions: options,
                                initialUserScripts:
                                    UnmodifiableListView<UserScript>([]),
                                contextMenu: contextMenu,
                                pullToRefreshController:
                                    pullToRefreshController,
                                onWebViewCreated:
                                    (InAppWebViewController controller) async {
                                  webViewController = controller;
                                  setState(() {});
                                },
                                onLoadStart: (controller, url) {
                                  Alerts.showLoading(context,
                                      loadingMessage: widget
                                          .webViewPageArgument!
                                          .loadingMessage!);
                                  setState(() {
                                    this.url = url.toString();
                                  });
                                },
                                androidOnPermissionRequest:
                                    (controller, origin, resources) async {
                                  return PermissionRequestResponse(
                                      resources: resources,
                                      action: PermissionRequestResponseAction
                                          .GRANT);
                                },
                                shouldOverrideUrlLoading:
                                    (controller, navigationAction) async {
                                  var uri = navigationAction.request.url!;

                                  if (![
                                    "http",
                                    "https",
                                    "file",
                                    "chrome",
                                    "data",
                                    "javascript",
                                    "about"
                                  ].contains(uri.scheme)) {
                                    // ignore: deprecated_member_use
                                    if (await canLaunch(url)) {
                                      // ignore: deprecated_member_use
                                      await launch(
                                        url,
                                      );
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  }

                                  return NavigationActionPolicy.ALLOW;
                                },
                                onLoadStop: (controller, Uri? url) async {
                                  BotToast.cleanAll();
                                  prints("LOAD STOP: $url");
                                  if (widget.webViewPageArgument!
                                          .whenSomeUrlConditionsMet !=
                                      null) {
                                    print("ALL MET");
                                    widget.webViewPageArgument!
                                            .whenSomeUrlConditionsMet!(
                                        url!.toString());
                                  }

                                  pullToRefreshController.endRefreshing();

                                  setState(() {
                                    this.url = url.toString();
                                  });
                                },
                                onLoadError: (controller, url, code, message) {
                                  prints("LOAD ERROR: $url");
                                  pullToRefreshController.endRefreshing();
                                  setState(() {
                                    progress = 0.0;
                                  });
                                },
                                onProgressChanged: (controller, progress) {
                                  if (progress == 1.0) {
                                    pullToRefreshController.endRefreshing();
                                  }
                                  setState(() {
                                    this.progress = progress.toDouble();
                                  });
                                },
                                onUpdateVisitedHistory:
                                    (controller, url, androidIsReload) {
                                  setState(() {
                                    this.url = url.toString();
                                    // urlController.text = this.url;
                                  });
                                },
                                onConsoleMessage:
                                    (controller, consoleMessage) {},
                              ),
                            ),
                            // widget.paymentUrl == null
                            //     ? Container(
                            //         padding: const EdgeInsets.symmetric(
                            //                 vertical: 10, horizontal: 20)
                            //             .add(const EdgeInsets.only(bottom: 10)),
                            //         color: AppTheme.white,
                            //         width: double.infinity,
                            //         child: Button(
                            //             title: "Accept",
                            //             press: () {
                            //               Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           widget.screenToGo!));
                            //             }))
                            //     : const SizedBox()
                          ],
                        ),
                        progress < 1.0
                            ? const LoadingPage()
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          )
        : ErrorPage(controller: webViewController);
  }
}
