import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'authentication.dart';
import 'constants.dart';

class GoogleSignInWebView extends StatefulWidget {
  const GoogleSignInWebView({super.key});

  @override
  State<GoogleSignInWebView> createState() => _GoogleSignInWebViewState();
}

class _GoogleSignInWebViewState extends State<GoogleSignInWebView> {
  final Authentication authcontroller = Get.find();
  late final WebViewController _controller;
  ValueNotifier<bool> loading = ValueNotifier(true);

  @override
  void initState() {
    var url =
        "${Constants.authUrl}/oauth2/authorize?identity_provider=Google&client_id=${Constants.clientId}&response_type=code&scope=email+openid+phone&redirect_uri=myapp://";
    _controller = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log("========>   PROGRESS :::::  $progress");
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            loading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            log("=======>  ERROR ::::  ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            log("========>   Navigate ::::  ${request.url}");
            if (request.url.startsWith("myapp://?code=")) {
              String code = request.url.substring("myapp://?code=".length);
              log("======>  Auth Code ::::  $code");
              Get.back();
              authcontroller.signUserInWithAuthCode(code);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: Get.mediaQuery.padding.top),
          Expanded(
            child: WebViewWidget(
              controller: _controller,
              // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              //     Factory<VerticalDragGestureRecognizer>(
              //       () => VerticalDragGestureRecognizer(),
              //     ),
              //     Factory<HorizontalDragGestureRecognizer>(
              //       () => HorizontalDragGestureRecognizer(),
              //     ),
              //   },
            ),
          ),
        ],
      ),
    );
  }
}
