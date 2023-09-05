import 'dart:io';

import 'package:datamites/helper/color.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternalWebView extends StatefulWidget {
  late String external_url;

  InternalWebView(String external_url){
    this.external_url = external_url;
  }
  @override
  InternalWebViewState createState() => InternalWebViewState();
}

class InternalWebViewState extends State<InternalWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: MainColor.textColorConst,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: MainColor.textColorConst,
            ),
            onPressed: () {
              Share.share(widget.external_url);
            },
          ),
        ],
      ),
      body: SafeArea(
          child: WebView(
            initialUrl: widget.external_url,
          )
      ),
    );
  }
}