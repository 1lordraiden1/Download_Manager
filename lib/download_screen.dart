import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. FieDownloadScreenidget subclass are
  // always marked "final".

  final String title;

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  TextEditingController fileName = TextEditingController();
  String downloadMessage = "Initializing...";
  bool _isDownloading = false;
  double _progress = 0.0;

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
              onPressed: () async {
                setState(() {
                  _isDownloading = !_isDownloading;
                });

                var dir = await getExternalStorageDirectory();

                Dio dio = Dio();
                dio.download(
                  fileName.text,
                  "${dir!.path}/sample.jpg",
                  onReceiveProgress: (count, total) {
                    var precentage = (count / total ) * 100;
                    if(precentage < 100){
                       _progress = precentage / 100;
                    setState(() {
                      downloadMessage = 'Downloading.. ${precentage.floor()} %';
                    });
                    } else {
                      setState(() {
                        downloadMessage = "Successfully downloaded !" ;
                      });
                    }
                  },
                );
              },
              child: Text("Download"),
              style: ButtonStyle(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(downloadMessage ?? '', style: Theme.of(context).textTheme.headlineMedium,),
            SizedBox(
              height: 20,
            ),
            LinearProgressIndicator(value: _progress,)
          ],
        ),
      ),
    );
  }
}
