import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'document.dart';

class PdfDemo extends StatefulWidget {
  @override
  PdfDemoState createState() {
    return PdfDemoState();
  }
}

class PdfDemoState extends State<PdfDemo> {
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();

  @override
  void initState() {
    _printPdf();
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  Future<void> _printPdf() async {
    print('Print ...');
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async =>
            (await generateDocument(format)).save());
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: previewContainer,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pdf Printing Example'),
          ),
          body: Center(),
        ));
  }
}
