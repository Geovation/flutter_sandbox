import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
  bool isBackCamera = true;
  List<bool> isSelectedLensDirection = [true, false];
  List<bool> isSelectedCameraMode = [true, false];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      if (widget.cameras.isNotEmpty) {
        _controller = CameraController(
          widget.cameras[cameraNumber],
          ResolutionPreset.veryHigh,
        );
        _initializeControllerFuture = _controller.initialize();
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    if (!kIsWeb) {
      if (widget.cameras.isNotEmpty) {
        _controller.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'camera_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex = _pageNavigator.getPageIndex('Camera');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    MediaQueryData deviceData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context);

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

    Widget portraitView = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Spacer(),
        ExcludeSemantics(
          excluding: true,
          child: Container(
            padding: EdgeInsets.all(10),
            height: deviceData.size.height * 0.7,
            width: deviceData.size.width * 0.9,
            child: FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: SizedBox(
                          height: deviceData.size.height * 0.7,
                          width: deviceData.size.width * 0.9,
                          child: CameraPreview(_controller)),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            color: Colors.black,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Semantics(
                    toggled: true,
                    value: isSelectedLensDirection[0]
                        ? localizations.semCameraPgRearCameraSelected
                        : localizations.semCameraPgFrontCameraSelected,
                    label: localizations.semCameraPgLensDirectionToggle,
                    child: ToggleButtons(
                      color: Colors.grey.shade100,
                      fillColor: Colors.orange.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      children: <Widget>[
                        Icon(
                          Icons.camera_rear_rounded,
                          semanticLabel:
                              localizations.semCameraPgRearCameraToggleButton,
                        ),
                        Icon(
                          Icons.camera_front_rounded,
                          semanticLabel:
                              localizations.semCameraPgFrontCameraToggleButton,
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelectedLensDirection.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelectedLensDirection[buttonIndex] = true;
                              _controller = CameraController(
                                widget.cameras[index],
                                ResolutionPreset.veryHigh,
                              );
                              _initializeControllerFuture =
                                  _controller.initialize();
                            } else {
                              isSelectedLensDirection[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelectedLensDirection,
                    ),
                  ),
                  Semantics(
                    toggled: true,
                    value: isSelectedCameraMode[0]
                        ? localizations.semCameraPgStillCameraModeSelected
                        : localizations.semCameraPgVideoCameraModeSelected,
                    label: localizations.semCameraPgCameraModeToggle,
                    child: ToggleButtons(
                      color: Colors.grey.shade100,
                      fillColor: Colors.red.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          semanticLabel:
                              localizations.semCameraPgStillCameraToggleButton,
                        ),
                        Icon(
                          Icons.videocam,
                          semanticLabel:
                              localizations.semCameraPgVideoCameraToggleButton,
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelectedCameraMode.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelectedCameraMode[buttonIndex] = true;
                            } else {
                              isSelectedCameraMode[buttonIndex] = false;
                            }
                          }
                          if (index == 0) {
                            isTakePicture = true;
                          } else {
                            isTakePicture = false;
                          }
                        });
                      },
                      isSelected: isSelectedCameraMode,
                    ),
                  ),
                  Semantics(
                    button: true,
                    child: MaterialButton(
                      onPressed: isTakePicture ? takePicture : recordVideo,
                      color: Colors.grey.shade800,
                      child: isTakePicture
                          ? Icon(
                              Icons.circle,
                              size: 60,
                              color: Colors.white,
                              semanticLabel: localizations
                                  .semCameraPgTakeStillCameraButton,
                            )
                          : Icon(
                              Icons.circle,
                              size: 60,
                              color: Colors.redAccent,
                              semanticLabel: localizations
                                  .semCameraPgTakeVideoCameraButton,
                            ),
                      padding: EdgeInsets.all(1),
                      shape: CircleBorder(),
                    ),
                  ),
                  MaterialButton(
                    onPressed: isRecording ? stopRecording : null,
                    color: isRecording ? Colors.redAccent : Colors.transparent,
                    child: isRecording
                        ? Icon(
                            Icons.stop,
                            size: 40,
                            color: Colors.black,
                            semanticLabel:
                                localizations.semCameraPgStopVideoCameraButton,
                          )
                        : null,
                    padding: EdgeInsets.all(1),
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    Widget landscapeView = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        Container(
          padding: EdgeInsets.all(10),
          height: deviceData.size.height * 0.7,
          width: deviceData.size.width * 0.7,
          child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SizedBox(
                        height: deviceData.size.height * 0.7,
                        width: deviceData.size.width * 0.7,
                        child: CameraPreview(_controller)),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
        Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Card(
            color: Colors.black,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ToggleButtons(
                        direction: Axis.vertical,
                        color: Colors.grey.shade100,
                        fillColor: Colors.orange.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        children: <Widget>[
                          Icon(
                            Icons.camera_rear_rounded,
                            semanticLabel:
                                localizations.semCameraPgRearCameraToggleButton,
                          ),
                          Icon(
                            Icons.camera_front_rounded,
                            semanticLabel: localizations
                                .semCameraPgFrontCameraToggleButton,
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelectedLensDirection.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelectedLensDirection[buttonIndex] = true;
                                _controller = CameraController(
                                  widget.cameras[index],
                                  ResolutionPreset.veryHigh,
                                );
                                _initializeControllerFuture =
                                    _controller.initialize();
                              } else {
                                isSelectedLensDirection[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: isSelectedLensDirection,
                      ),
                      ToggleButtons(
                        direction: Axis.vertical,
                        color: Colors.grey.shade100,
                        fillColor: Colors.red.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            semanticLabel: localizations
                                .semCameraPgStillCameraToggleButton,
                          ),
                          Icon(
                            Icons.videocam,
                            semanticLabel: localizations
                                .semCameraPgVideoCameraToggleButton,
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelectedCameraMode.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelectedCameraMode[buttonIndex] = true;
                              } else {
                                isSelectedCameraMode[buttonIndex] = false;
                              }
                            }
                            if (index == 0) {
                              isTakePicture = true;
                            } else {
                              isTakePicture = false;
                            }
                          });
                        },
                        isSelected: isSelectedCameraMode,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: isTakePicture ? takePicture : recordVideo,
                        color: Colors.grey.shade800,
                        child: isTakePicture
                            ? Icon(
                                Icons.circle,
                                size: 60,
                                color: Colors.white,
                                semanticLabel: localizations
                                    .semCameraPgTakeStillCameraButton,
                              )
                            : Icon(
                                Icons.circle,
                                size: 60,
                                color: Colors.redAccent,
                                semanticLabel: localizations
                                    .semCameraPgTakeVideoCameraButton,
                              ),
                        padding: EdgeInsets.all(1),
                        shape: CircleBorder(),
                      ),
                      isRecording
                          ? MaterialButton(
                              onPressed: stopRecording,
                              color: Colors.redAccent,
                              child: Icon(
                                Icons.stop,
                                size: 40,
                                color: Colors.black,
                                semanticLabel: localizations
                                    .semCameraPgStopVideoCameraButton,
                              ),
                              padding: EdgeInsets.all(1),
                              shape: CircleBorder(),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    if (!kIsWeb && widget.cameras.isNotEmpty) {
      bodyWidget = OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return SafeArea(
            child: Container(
              color: Colors.black,
              child: portraitView,
            ),
          );
        } else {
          return SafeArea(
            child: Container(
              color: Colors.black,
              child: landscapeView,
            ),
          );
        }
      });
    } else {
      bodyWidget = Container(
        child: Center(
          child: Text(localizations.cameraNotSupportedText),
        ),
      );
    }
    return bodyWidget;
  }
}
