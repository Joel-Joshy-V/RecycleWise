import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/tflite_service.dart';

class RealtimeDetectionScreen extends StatefulWidget {
  const RealtimeDetectionScreen({Key? key}) : super(key: key);

  @override
  State<RealtimeDetectionScreen> createState() => _RealtimeDetectionScreenState();
}

class _RealtimeDetectionScreenState extends State<RealtimeDetectionScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  String _result = 'Detecting...';
  bool _isDetecting = false;
  final TFLiteService _tfliteService = TFLiteService();

  @override
  void initState() {
    super.initState();
    _tfliteService.loadModel().then((_) => _initializeCamera());
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.medium, enableAudio: false);
    _initializeControllerFuture = _cameraController.initialize();
    await _initializeControllerFuture;
    _cameraController.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;
      try {
        // Implement conversion from CameraImage to File (or directly to Float32List).
        File convertedImage = await convertCameraImageToFile(image);
        String label = await _tfliteService.runInference(convertedImage);
        setState(() { _result = label; });
      } catch (e) {
        print("Error during real-time inference: $e");
      }
      _isDetecting = false;
    });
  }

  Future<File> convertCameraImageToFile(CameraImage image) async {
    // IMPLEMENT: Convert YUV420 CameraImage to an RGB File.
    throw UnimplementedError("Camera image conversion not implemented.");
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _tfliteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_cameraController),
              Positioned(
                bottom: 30,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Detected: $_result',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
