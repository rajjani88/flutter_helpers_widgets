import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController _controller;

  void _printWebPage() async {
    await _controller.evaluateJavascript(source: 'window.print();');
  }

  Future<void> _shareAsPDF() async {
    try {
      // Extract HTML content
      String? htmlContent = await _controller.evaluateJavascript(
          source: "document.documentElement.outerHTML;");

      // if (htmlContent != null && htmlContent.isNotEmpty) {
      //   // Generate PDF
      //   final Directory tempDir = await getTemporaryDirectory();
      //   final String outputPath =
      //       (await FlutterHtmlToPdf.convertFromHtmlContent(
      //     htmlContent,
      //     tempDir.path,
      //     'payslip',
      //   )) as String;

      //   // Share PDF
      //   Share.shareXFiles([XFile(outputPath)], text: 'Payslip PDF');
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Failed to retrieve HTML content.')),
      //   );
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payslip Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printWebPage,
          ),
          // IconButton(
          //   icon: Icon(Icons.share),
          //   onPressed: _shareAsPDF,
          // ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
      ),
    );
  }
}
