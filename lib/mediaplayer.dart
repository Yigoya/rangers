import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class MediaScreen extends StatefulWidget {
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/sample_video.mp4');
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(true);
  }

  Future<String> getMediaPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String mediaPath = '${directory.path}/media';
    Directory(mediaPath).createSync(recursive: true);
    return mediaPath;
  }

  String _imagepath = 'assets/sample_image.png';
  Future<String> pickAndSaveImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final mediaPath = await getMediaPath();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      File destination = File('$mediaPath/$fileName');
      File img = await File(pickedFile.path).copy(destination.path);
      setState(() {
        _imagepath = img.path;
      });
      return img.toString();
    } else {
      return '';
    }
  }

  Future<void> pickAndSaveVideo() async {
    XFile? pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final mediaPath = await getMediaPath();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      File destination = File('$mediaPath/$fileName');
      await File(pickedFile.path).copy(destination.path);
    }
  }
  // '/data/user/0/com.example.rangers/app_flutter/media/1701155903907.jpg'

  Future<void> _saveImage() async {
    final imagePath = await pickAndSaveImage();
    // final imagePath = await _getFilePath('1701155721308.jpg');
    // Here, you can replace the sample image file with your own image file.
    // Make sure to copy your image file to the correct path in the device.
    File(imagePath).copySync('assets/sample_image.png');
  }

  Future<String> _getFilePath(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();

    return '${directory.path}/media/$fileName';
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter File Operations'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  pickAndSaveImage();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image saved successfully!'),
                    ),
                  );
                },
                child: Text('Save Image'),
              ),
              Image.asset(_imagepath),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _videoController.play();
                },
                child: Text('Play Video'),
              ),
              ElevatedButton(
                onPressed: () {
                  _videoController.pause();
                  _videoController.videoPlayerOptions;
                },
                child: Text('pause Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
