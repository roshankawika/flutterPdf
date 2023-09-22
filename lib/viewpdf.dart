import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  PdfViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: PDFView(
          filePath: pdfPath,
          onRender: (pages) {
            // PDF document is rendered
          },
          onError: (error) {
            // Handle any errors that occur during rendering
            print(error.toString());
          },
          onPageError: (page, error) {
            // Handle errors on specific pages
            print('Page $page: $error');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            // You can use pdfViewController to control the PDF view
          },
          // If you want to enable swipe gestures for page navigation
          swipeHorizontal: true,
        ),
      ),
    );
  }
}
