import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

import 'display_picture_screen.dart';
import 'display_video_screen.dart';

class CameraPage extends StatefulWidget {
  static const id = 'camera_page';
  final List<CameraDescription> cameras;

  CameraPage({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  int cameraNumber = 0;
  Function cameraModeFunction;
  bool isTakePicture = true;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = CameraController(
        widget.cameras[cameraNumber],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    if (!kIsWeb) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Function takePicture = () async {
      try {
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;
        _controller.setFlashMode(FlashMode.off);
        _controller.setFocusMode(FocusMode.auto);

        var appDocDir = await getApplicationDocumentsDirectory();
        String savePath =
            appDocDir.path + "/${DateTime.now().toUtc().toIso8601String()}.jpg";

        final image = await _controller.takePicture();
        final processedImage = decodeImage(File(image?.path).readAsBytesSync());

        File(savePath).writeAsBytesSync(encodeJpg(processedImage));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: savePath,
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
    };

    Function recordVideo = () async {
      try {
        await _initializeControllerFuture;
        _controller.setFocusMode(FocusMode.auto);
        await _controller.startVideoRecording();

        setState(() {
          isRecording = true;
        });
      } catch (e) {
        print(e);
      }
    };

    Function stopRecording = () async {
      try {
        final video = await _controller.stopVideoRecording();

        setState(() {
          isRecording = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayVideoView(videoFile: video),
          ),
        );
      } catch (e) {
        print(e);
      }
    };
    Widget bodyWidget;

    if (!kIsWeb) {
      bodyWidget = Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                );
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    cameraNumber = 1;
                    _controller = CameraController(
                      widget.cameras[cameraNumber],
                      ResolutionPreset.ultraHigh,
                    );
                    _initializeControllerFuture = _controller.initialize();
                  });
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text('Front Camera'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    cameraNumber = 0;
                    _controller = CameraController(
                      widget.cameras[cameraNumber],
                      ResolutionPreset.medium,
                    );
                    _initializeControllerFuture = _controller.initialize();
                  });
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text('Back Camera'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isTakePicture = true;
                  });
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text('Take Picture'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isTakePicture = false;
                  });
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text('Record Video'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: isTakePicture ? takePicture : recordVideo,
                  color: Colors.blue,
                  child: isTakePicture
                      ? Icon(
                          Icons.camera,
                          size: 40,
                        )
                      : Icon(
                          Icons.videocam,
                          size: 40,
                        ),
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(),
                ),
                MaterialButton(
                  onPressed: isRecording ? stopRecording : null,
                  color: isRecording ? Colors.blue : Colors.transparent,
                  child: isRecording
                      ? Icon(
                          Icons.stop,
                          size: 30,
                        )
                      : null,
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      bodyWidget = Container(
        child: Center(
          child: Text('Camera is not supported yet on this platform.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: bodyWidget,
    );
  }
}
