import 'dart:io';

import 'package:download_app/download_screen.dart';
import 'package:download_app/notifications.dart';
import 'package:flutter/material.dart';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Download App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DownloadScreen(title: "Download App") //const MyHomePage(title: 'Download Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _download = MediaDownload();
  TextEditingController fileName = TextEditingController();
  var _progress = 0.0;

  @override
  void initState() {
    Nots.initialize(localNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Download all files you need by pasting the URL below',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: fileName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    hintText: "Paste URL here"),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                
                // Download 
                FileDownloader.downloadFile(notificationType: NotificationType.all,
                  url: fileName.text,
                  
                  onDownloadError: (String error) {
                    print('Download error : $error');
                  },
                  onDownloadCompleted: (path) {
                    final File file = File(path);
                    print(file);
                    fileName.clear();
                  },
                  onProgress: (fileName, progress) {
                    setState(() {
                      _progress = progress;

                    });
                  },
                );

              },
              child: Text("Download"),
              style: ButtonStyle(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 20,
              width: _progress * 4,
              color: _progress == 100.0 ? Colors.green :  Colors.red,
            ),
            Text('${_progress} %')
          ],
        ),
      ),
    );
  }
}
