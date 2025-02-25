import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/tflite_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _result = 'Scan a waste item to see result';
  bool _isLoading = false;

  // Instance of our TFLiteService
  final TFLiteService _tfliteService = TFLiteService();

  @override
  void initState() {
    super.initState();
    _tfliteService.loadModel();  // Load model on initialization
  }

  // Capture an image using the device camera.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });
      _image = File(pickedFile.path);
      String prediction = await _tfliteService.runInference(_image!);
      setState(() {
        _result = prediction;
        _isLoading = false;
      });
      // Optionally, log this scan data to backend for points/carbon credit calculation.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 300, fit: BoxFit.cover)
                : Icon(Icons.image, size: 200, color: Colors.grey),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Text(
                    'Detected Waste: $_result',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.camera_alt),
              label: Text('Scan Waste'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
