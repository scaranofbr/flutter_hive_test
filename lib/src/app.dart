import 'package:flutter/material.dart';
import 'package:flutter_hive_test/src/screen/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _hiveFuture;

  Future<void> _initLocalHive() async {
    await Hive.initFlutter();
    await Hive.openBox<String>('images');
  }

  @override
  void initState() {
    _hiveFuture = _initLocalHive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _hiveFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());
          return Homepage();
        },
      ),
    );
  }
}
