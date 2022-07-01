import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatelessWidget {
  const BrowserPage({Key? key, required this.url, required this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
