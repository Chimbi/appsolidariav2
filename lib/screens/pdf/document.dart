import 'dart:async';

import 'package:flutter/material.dart' as mw;
import 'package:flutter/widgets.dart' as fw;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const PdfColor black = PdfColor.fromInt(0x000000);
const PdfColor grey = PdfColor.fromInt(0xA9A9A9);

class MyPage extends Page {
  MyPage(
      {PdfPageFormat pageFormat = PdfPageFormat.a4,
      BuildCallback build,
      EdgeInsets margin})
      : super(pageFormat: pageFormat, margin: margin, build: build);

  @override
  void paint(Widget child, Context context) {
    context.canvas
        /*..setColor(lightGreen)
      ..moveTo(0, pageFormat.height)
      ..lineTo(0, pageFormat.height - 230)
      ..lineTo(60, pageFormat.height)
      ..fillPath()
      ..setColor(green)
      ..moveTo(0, pageFormat.height)
      ..lineTo(0, pageFormat.height - 100)
      ..lineTo(100, pageFormat.height)
      ..fillPath()
      ..setColor(lightGreen)
      ..moveTo(30, pageFormat.height)
      ..lineTo(110, pageFormat.height - 50)
      ..lineTo(150, pageFormat.height)
      ..fillPath()
      ..moveTo(pageFormat.width, 0)
      ..lineTo(pageFormat.width, 230)
      ..lineTo(pageFormat.width - 60, 0)
      ..fillPath()
      ..setColor(green)
      ..moveTo(pageFormat.width, 0)
      ..lineTo(pageFormat.width, 100)
      ..lineTo(pageFormat.width - 100, 0)
      ..fillPath()
      ..setColor(lightGreen)
      ..moveTo(pageFormat.width - 30, 0)
      ..lineTo(pageFormat.width - 110, 50)
      ..lineTo(pageFormat.width - 150, 0)
      ..fillPath()*/
        ;

    super.paint(child, context);
  }
}

class Block extends StatelessWidget {
  Block({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 2.5, left: 2, right: 5),
              decoration:
                  const BoxDecoration(color: green, shape: BoxShape.circle),
            ),
            Text(title,
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(fontWeight: FontWeight.bold)),
          ]),
          Container(
            decoration: const BoxDecoration(
                border: BoxBorder(left: true, color: green, width: 2)),
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const EdgeInsets.only(left: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Lorem(length: 20),
                ]),
          ),
        ]);
  }
}

class Category extends StatelessWidget {
  Category({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Container(
        decoration: const BoxDecoration(color: lightGreen, borderRadius: 6),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
        child: Text(title, textScaleFactor: 1.5));
  }
}

class TitleText extends StatelessWidget {
  TitleText({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title, style: TextStyle(fontSize: 8));
  }
}

class TitleTextValue extends StatelessWidget {
  TitleTextValue({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold));
  }
}

class BlackBoldText extends StatelessWidget {
  BlackBoldText({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title,
        style:
            TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: black));
  }
}

class NormalText extends StatelessWidget {
  NormalText({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title, style: TextStyle(fontSize: 8, color: black));
  }
}

Future<Document> generateDocument(PdfPageFormat format) async {

  List temp = [
    {
      'id': 1,
      'question': 'How was your experience with us?',
      'question_type': 'radio',
      'from_date': '1-6-2019',
      'to_date': '10-6-2019',
      'ans_array': [{'ans_id':1, 'ans':'Yes'},{'ans_id':1, 'ans':'No'}]
    },
  ];


  final PdfDoc pdf = PdfDoc(title: 'My Résumé', author: 'David PHAM-VAN');

  final PdfImage profileImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: const fw.NetworkImage(
          'https://i.ibb.co/dQDz2ys/logo-Solidaria.png'),
      onError: (dynamic exception, StackTrace stackTrace) {
        print('Unable to download image');
      });

  var assetsImage = new mw.AssetImage('assets/logo.png');
  var image = new mw.Image(image: assetsImage);

  pdf.addPage(
    MyPage(
      pageFormat: format.applyMargin(
          left: 0.3 * PdfPageFormat.cm,
          top: 0.3 * PdfPageFormat.cm,
          right: 0.3 * PdfPageFormat.cm,
          bottom: 0.3 * PdfPageFormat.cm),
      build: (Context context) => Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 55,
              alignment: Alignment.centerLeft,
              child: Image(profileImage, fit: BoxFit.contain),
            ),
            Container(
                margin: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: BoxBorder(
                      left: true,
                      top: true,
                      bottom: true,
                      right: true,
                      color: grey,
                      width: 1),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          TitleText(title: "AGENCIA EXPEDIDORA:"),
                          TitleTextValue(title: "  BOGOTÁ CALLE 100")
                        ]),
                        Row(children: <Widget>[
                          Row(children: <Widget>[
                            TitleText(title: "COD. AGENCIA:"),
                            TitleText(title: "  376")
                          ]),
                          Container(width: 10),
                          Row(children: <Widget>[
                            TitleText(title: "RAMO:"),
                            TitleText(title: "  45")
                          ]),
                          Container(width: 100),
                        ]),
                      ]),
                  Container(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          TitleText(title: "TIPO DE MOVIMIENTO:"),
                          TitleTextValue(title: "  EXPEDICION")
                        ]),
                        Row(children: <Widget>[
                          TitleText(title: "TIPO DE IMPRESIÓN:"),
                          TitleText(title: "  REIMPRESION")
                        ]),
                        Row(children: <Widget>[
                          Row(children: <Widget>[
                            Column(children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: 22,
                                  child: NormalText(title: 'DIA'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  child: NormalText(title: 'MES'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 33,
                                  child: NormalText(title: 'AÑO'),
                                ),
                              ]),
                              Container(margin: EdgeInsets.only(bottom: 2)),
                              Row(children: <Widget>[
                                Container(width: 1, height: 11, color: black),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  child: BlackBoldText(title: '23'),
                                ),
                                Container(height: 11, width: 1, color: black),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  child: BlackBoldText(title: '05'),
                                ),
                                Container(height: 11, width: 1, color: black),
                                Container(
                                  alignment: Alignment.center,
                                  width: 31,
                                  child: BlackBoldText(title: '2017'),
                                ),
                                Container(height: 11, width: 1, color: black),
                              ]),
                              Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  height: 1,
                                  width: 75,
                                  color: black),
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Text("FECHA DE EXPEDICIÓN",
                                    style: TextStyle(fontSize: 5)),
                              )
                            ]),
                          ]),
                          Container(width: 10),
                          Row(children: <Widget>[
                            Column(children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: 22,
                                  child: NormalText(title: 'DIA'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  child: NormalText(title: 'MES'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 33,
                                  child: NormalText(title: 'AÑO'),
                                ),
                              ]),
                              Container(margin: EdgeInsets.only(bottom: 2)),
                              Row(children: <Widget>[
                                Container(width: 1, height: 11, color: black),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  child: BlackBoldText(title: '23'),
                                ),
                                Container(height: 11, width: 1, color: black),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  child: BlackBoldText(title: '05'),
                                ),
                                Container(height: 11, width: 1, color: black),
                                Container(
                                  alignment: Alignment.center,
                                  width: 31,
                                  child: BlackBoldText(title: '2017'),
                                ),
                                Container(height: 11, width: 1, color: black),
                              ]),
                              Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  height: 1,
                                  width: 75,
                                  color: black),
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Text("FECHA DE IMPRESIÓN",
                                    style: TextStyle(fontSize: 5)),
                              )
                            ]),
                          ]),
                        ])
                      ]),
                ]))
          ]),

      /* Column(children: <Widget>[
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 30, bottom: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Parnella Charlesbois',
                              textScaleFactor: 2,
                              style: Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(fontWeight: FontWeight.bold)),
                          Padding(padding: const EdgeInsets.only(top: 10)),
                          Text('Electrotyper',
                              textScaleFactor: 1.2,
                              style: Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: green)),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('568 Port Washington Road'),
                                      Text('Nordegg, AB T0M 2H0'),
                                      Text('Canada, ON'),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('+1 403-721-6898'),
                                      Text('p.charlesbois@yahoo.com'),
                                      Text('wholeprices.ca')
                                    ]),
                                Padding(padding: EdgeInsets.zero)
                              ]),
                        ])),
                Category(title: 'Work Experience'),
                Block(title: 'Tour bus driver'),
                Block(title: 'Logging equipment operator'),
                Block(title: 'Foot doctor'),
                Category(title: 'Education'),
                Block(title: 'Bachelor Of Commerce'),
                Block(title: 'Bachelor Interior Design'),
              ])),
          Container(
            height: double.infinity,
            width: 10,
            decoration: const BoxDecoration(
                border: BoxBorder(left: true, color: green, width: 2)),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                    child: Container(
                        width: 100,
                        height: 100,
                        color: lightGreen,
                        child: profileImage == null
                            ? Container()
                            : Image(profileImage)))
              ])
        ]*/
    ),
  );
  return pdf;
}
