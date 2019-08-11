import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart'
    show kTransparentImage;
import 'package:flutter/material.dart';

// NOTE: to add firebase support, first go to firebase console, generate the
// firebase json file, and add configuration lines in the gradle files.
// C.f. this commit: https://github.com/X-Wei/flutter_catalog/commit/48792cbc0de62fc47e0e9ba2cd3718117f4d73d1.

// Adapted from the flutter firestore "babyname voter" codelab:
// https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
class FirebaseMLKitExample extends StatefulWidget {
  const FirebaseMLKitExample({Key key}) : super(key: key);

  @override
  _FirebaseMLKitExampleState createState() => _FirebaseMLKitExampleState();
}

class _FirebaseMLKitExampleState extends State<FirebaseMLKitExample> {
  File _imageFile;
  String _mlResult = '<no result>';

  Future<bool> _pickImage() async {
    setState(() => this._imageFile = null);
    final File imageFile = await showDialog<File>(
      context: context,
      builder: (ctx) => SimpleDialog(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take picture'),
            onTap: () async {
              final File imageFile =
              await ImagePicker.pickImage(source: ImageSource.camera);
              Navigator.pop(ctx, imageFile);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Pick from gallery'),
            onTap: () async {
              try {
                final File imageFile =
                await ImagePicker.pickImage(source: ImageSource.gallery);
                Navigator.pop(ctx, imageFile);
              } catch (e) {
                print(e);
                Navigator.pop(ctx, null);
              }
            },
          ),
        ],
      ),
    );
    if (imageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Please pick one image first.')),
      );
      return false;
    }
    setState(() => this._imageFile = imageFile);
    print('picked image: ${this._imageFile}');
    return true;
  }


  Future<Null> _textOcr() async {
    setState(() => this._mlResult = '<no result>');
    if (await _pickImage() == false) {
      return;
    }
    String result = '';
    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFile(this._imageFile);
    final TextRecognizer textRecognizer =
    FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
    await textRecognizer.processImage(visionImage);
    final String text = visionText.text;
    result += 'Detected ${visionText.blocks.length} text blocks.\n';
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;
      result += '\n# Text block:\n '
          'bbox=$boundingBox\n '
          'cornerPoints=$cornerPoints\n '
          'text=$text\n languages=$languages';
      // for (TextLine line in block.lines) {
      //   // Same getters as TextBlock
      //   for (TextElement element in line.elements) {
      //     // Same getters as TextBlock
      //   }
      // }
    }
    if (result.length > 0) {
      setState(() => this._mlResult = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ML kit example"),
      ),
      body: ListView(
        children: <Widget>[
          this._imageFile == null
              ? Placeholder(
            fallbackHeight: 200.0,
          )
              : FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: FileImage(this._imageFile),
            // Image.file(, fit: BoxFit.contain),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ButtonBar(
              children: <Widget>[
                RaisedButton(
                  child: Text('Text OCR'),
                  onPressed: this._textOcr,
                ),
              ],
            ),
          ),
          Divider(),
          Text('Result:', style: Theme.of(context).textTheme.subtitle),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              this._mlResult,
              style: TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}