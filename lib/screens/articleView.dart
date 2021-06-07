import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class ArticleView extends StatefulWidget {
  final String webViewUrl;
  const ArticleView({
    Key? key,
    required this.webViewUrl,
  }) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter").text.black.make(),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            ).text.make(),
          ],
        ).pOnly(right: 45),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: WebView(
            initialUrl: widget.webViewUrl,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          )),
    );
  }
}
