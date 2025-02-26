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
    _tfliteService.loadModel();
  }

  Future<void> _pickAndScanImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _loading = true);
      
      try {
        File imageFile = File(pickedFile.path);
        String label = await _tfliteService.runInference(imageFile);
        int points = _calculatePoints(label);
        
        setState(() {
          _image = imageFile;
          _result = '${label.split("(")[0]}\nPoints: $points';
          _loading = false;
        });
      } catch (e) {
        setState(() {
          _loading = false;
          _result = 'Error: ${e.toString()}';
        });
      }
    }
  }

  int _calculatePoints(String label) {
    if (label.contains('plastic')) return 10;
    if (label.contains('paper')) return 8;
    if (label.contains('organic')) return 5;
    if (label.contains('e-waste')) return 20;
    if (label.contains('hygiene')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Waste'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 300, fit: BoxFit.cover)
                : Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                    ),
                  ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        'Detection Result:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _pickAndScanImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Item', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}