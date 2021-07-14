import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Storage extends StatefulWidget {
  Storage({required this.downloadedImage, Key? key}) : super(key: key);

  Uint8List downloadedImage;

  @override
  _StorageState createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Storage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<Box<String>>(
                valueListenable: Hive.box<String>('images')
                    .listenable(keys: ['downloadedImage']),
                builder: (context, Box box, widget) {
                  var value = box.get('downloadedImage', defaultValue: null);
                  List<Widget> column = [
                    Text(value != null ? 'Stored Image' : 'Nothing to read yet')
                  ];
                  if (value != null)
                    column.add(Image.memory(base64Decode(value)));
                  return Column(
                    children: column,
                  );
                }),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Hive.box<String>('images')
                  .put('downloadedImage', base64Encode(widget.downloadedImage)),
              child: Text('Store downloaded image!'),
            ),
            ElevatedButton(
              onPressed: () => Hive.box<String>('images')
                  .delete('downloadedImage'),
              child: Text('Cleare storage'),
            ),
          ],
        ),
      ),
    );
  }
}
