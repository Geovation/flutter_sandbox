import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/google_ml_kit/painters/face_detector_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_view.dart';

class FaceDetectionView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  const FaceDetectionView({
    Key key,
    @required this.cameras,
    @required this.title,
  }) : super(key: key);

  @override
  _FaceDetectionViewState createState() => _FaceDetectionViewState();
}

class _FaceDetectionViewState extends State<FaceDetectionView> {
  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;
  CustomPaint customPaint;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CameraView(
        cameras: widget.cameras,
        customPaint: customPaint,
        onImage: (inputImage) {
          processImage(inputImage);
        },
        initialDirection: CameraLensDirection.back,
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(faces, inputImage.inputImageData.size,
          inputImage.inputImageData.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
