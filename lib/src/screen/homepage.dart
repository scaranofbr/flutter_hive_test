import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hive_test/src/screen/storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  StreamController<Uint8List?> _controller =
      StreamController<Uint8List?>.broadcast();

  _imageBytesFromUrl(String url) async {
    _controller.add(null);
    var response = await http.get(Uri.parse(url));
    _controller.add(response.bodyBytes);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    _imageBytesFromUrl('https://picsum.photos/400');
    super.initState();
  }

  _navigateToStorage(Uint8List image) {
    Navigator.push(
        context,
        MaterialPageRoute<Storage>(
            builder: (_) => Storage(
                  downloadedImage: image,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Image'),
        actions: [
          StreamBuilder<Uint8List?>(
            stream: _controller.stream,
            initialData: null,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: snapshot.hasData
                      ? () => _navigateToStorage(snapshot.data!)
                      : null,
                  icon: Icon(Icons.storage));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 400,
              child: StreamBuilder<Uint8List?>(
                stream: _controller.stream,
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    return Center(child: CircularProgressIndicator());
                  return Image.memory(snapshot.data!);
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<Uint8List?>(
              stream: _controller.stream,
              initialData: null,
              builder: (context, snapshot) {
                return ElevatedButton(
                  child: Text('Download again!'),
                  onPressed: snapshot.hasData
                      ? () => _imageBytesFromUrl('https://picsum.photos/400')
                      : null,
                );
              },
            )
          ],
        ),
      ),
      // body: FutureBuilder<Uint8List>(
      //   future: _imageBytes,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return Center(child: Image.memory(snapshot.data!));
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
