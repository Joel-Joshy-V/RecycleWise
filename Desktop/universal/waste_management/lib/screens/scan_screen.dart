import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/tflite_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _result = 'No image scanned yet';
  final TFLiteService _tfliteService = TFLiteService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Load the model when the screen initializes.
    _tfliteService.loadModel();
  }

  Future<void> _pickAndScanImage() async {
    // Pick an image using the camera.
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _loading = true;
      });
      File imageFile = File(pickedFile.path);
      // Run inference on the captured image.
      String label = await _tfliteService.runInference(imageFile);
      setState(() {
        _image = imageFile;
        _result = label;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the captured image or a placeholder.
          _image != null
              ? Image.file(_image!, height: 300, fit: BoxFit.cover)
              : Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
          const SizedBox(height: 20),
          // Show the detected label or a loading indicator.
          _loading
              ? const CircularProgressIndicator()
              : Text(
                  'Detected: $_result',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: 20),
          // Button to capture and scan an image.
          ElevatedButton.icon(
            onPressed: _pickAndScanImage,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan Image'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
