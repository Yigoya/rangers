import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class DownloadAndSaveFile extends StatefulWidget {
  const DownloadAndSaveFile({super.key});

  @override
  State<DownloadAndSaveFile> createState() => _DownloadAndSaveFileState();
}

class _DownloadAndSaveFileState extends State<DownloadAndSaveFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => openFile(
                    url: 'https://youtu.be/6tfBflFUO7s', fileName: 'video.mp4'),
                child: Text('Download and Open'))
          ],
        ),
      ),
    );
  }

  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    // final file = await downloadFile(url, name);
    final file = await pickFile();
    if (file == null) return;
    print('Path: ${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;

    return File(result.files.first.path!);
  }

  Future<File?> downloadFile(String url, String? name) async {
    final appStorage = await getApplicationCacheDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: Duration(seconds: 0)));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
