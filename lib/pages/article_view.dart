import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;

  const ArticleView({super.key, required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late String fixedUrl;
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
    fixedUrl = _fixUrl(widget.blogUrl);
  }

  String _fixUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("News"),
            Text(
              "Hive",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url:WebUri(fixedUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
