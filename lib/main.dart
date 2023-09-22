import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttpdf/viewpdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfGenerator(),
    );
  }
}

class PdfGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Declaration PDF Generator'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _generatePdf(context);
          },
          child: Text('Generate PDF'),
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final pdf = pw.Document();

      final ttf = await rootBundle.load(
          "assets/fonts/Roboto/Roboto-Bold.ttf"); // Replace with your custom font file
      final font = pw.Font.ttf(ttf);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(
                    'Declaration of Intent',
                    style: pw.TextStyle(font: font, fontSize: 20),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'I hereby declare my intentions as follows:',
                    style: pw.TextStyle(font: font, fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    '1. Statement 1',
                    style: pw.TextStyle(font: font, fontSize: 14),
                  ),
                  pw.Text(
                    '2. Statement 2',
                    style: pw.TextStyle(font: font, fontSize: 14),
                  ),
                  pw.Text(
                    '3. Statement 3',
                    style: pw.TextStyle(font: font, fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory?.path}/declaration.pdf';

      final File file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Show a message after successful PDF generation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF generated successfully: $filePath'),
      ));

      // Open the PDF viewer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(
              pdfPath: filePath), // Provide the path to your PDF
        ),
      );
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission to write files denied'),
      ));
    }
  }
}
