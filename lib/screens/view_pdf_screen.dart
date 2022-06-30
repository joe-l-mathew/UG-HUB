import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfFromUrl extends StatelessWidget {
  final String url;
  const ViewPdfFromUrl({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SfPdfViewer.network(
      url,
      canShowHyperlinkDialog: false,
    )));
  }
}
