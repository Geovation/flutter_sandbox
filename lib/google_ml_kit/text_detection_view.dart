import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/google_ml_kit/painters/text_detector_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_view.dart';

class TextDetectionView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  const TextDetectionView({
    Key key,
    @required this.cameras,
    @required this.title,
  }) : super(key: key);

  @override
  _TextDetectionViewState createState() => _TextDetectionViewState();
}

class _TextDetectionViewState extends State<TextDetectionView> {
  final textDetector = GoogleMlKit.vision.textDetector();
  bool isBusy = false;
  CustomPaint customPaint;

  @override
  void dispose() {
    textDetector.close();
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
    final recognisedText = await textDetector.processImage(inputImage);
    print('Found ${recognisedText.blocks.length} textBlocks');
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextDetectorPainter(
          recognisedText,
          inputImage.inputImageData.size,
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
