import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/google_ml_kit/camera_view.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'painters/barcode_detector_painter.dart';

class BarcodeScannerView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  const BarcodeScannerView({
    Key key,
    @required this.cameras,
    @required this.title,
  }) : super(key: key);

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  bool isBusy = false;
  CustomPaint customPaint;

  @override
  void dispose() {
    barcodeScanner.close();
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
    final barcodes = await barcodeScanner.processImage(inputImage);
    if (inputImage.inputImageData.size != null &&
        inputImage.inputImageData.imageRotation != null) {
      final painter = BarcodeDetectorPainter(
          barcodes,
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
