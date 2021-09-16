import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/google_ml_kit/painters/image_label_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_view.dart';

class ImageLabelView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  const ImageLabelView({
    Key key,
    @required this.cameras,
    @required this.title,
  }) : super(key: key);
  @override
  _ImageLabelViewState createState() => _ImageLabelViewState();
}

class _ImageLabelViewState extends State<ImageLabelView> {
  ImageLabeler imageLabeler = GoogleMlKit.vision.imageLabeler();
  bool isBusy = false;
  CustomPaint customPaint;

  @override
  void dispose() {
    imageLabeler.close();
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
          processImageWithDefaultModel(inputImage);
          //processImageWithRemoteModel(inputImage);
        },
        initialDirection: CameraLensDirection.back,
      ),
    );
  }

  Future<void> processImageWithDefaultModel(InputImage inputImage) async {
    imageLabeler = GoogleMlKit.vision.imageLabeler();
    processImage(inputImage);
  }

  // Add the tflite model in android/src/main/assets
  Future<void> processImageWithRemoteModel(InputImage inputImage) async {
    final options = CustomRemoteLabelerOption(
        confidenceThreshold: 0.5, modelName: 'bird-classifier');
    imageLabeler = GoogleMlKit.vision.imageLabeler(options);
    processImage(inputImage);
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    await Future.delayed(Duration(milliseconds: 50));
    final labels = await imageLabeler.processImage(inputImage);
    final painter = LabelDetectorPainter(labels);
    customPaint = CustomPaint(painter: painter);
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
