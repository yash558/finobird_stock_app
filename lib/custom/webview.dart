import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatelessWidget {
  Webview({super.key, required this.url});
  final String url;

  final WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    controller.loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4AB5E5),
        elevation: 0,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
