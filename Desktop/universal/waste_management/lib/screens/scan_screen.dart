import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/tflite_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _result = 'Ready to scan';
  final TFLiteService _tfliteService = TFLiteService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      await _tfliteService.loadModel();
    } catch (e) {
      setState(() => _result = 'Model failed to load');
    }
  }

  Future<void> _scanImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;

    setState(() {
      _loading = true;
      _result = 'Processing...';
    });

    try {
      final imageFile = File(file.path);
      final result = await _tfliteService.runInference(imageFile);
      final points = _calculatePoints(result);

      setState(() {
        _image = imageFile;
        _result = '${result.split("(")[0]}\nPoints Earned: $points';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _result = 'Scan failed';
      });
    }
  }

  int _calculatePoints(String label) {
    if (label.contains('plastic')) return 10;
    if (label.contains('e-waste')) return 20;
    if (label.contains('paper')) return 8;
    if (label.contains('organic')) return 5;
    if (label.contains('hygiene')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Scanner'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_camera, size: 80),
                            Text('No image scanned'),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _loading
                      ? const CircularProgressIndicator()
                      : Text(
                          _result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Scan Waste Item'),
                      onPressed: _scanImage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tfliteService.dispose();
    super.dispose();
  }
}