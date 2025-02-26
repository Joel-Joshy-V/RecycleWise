import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> loadModel() async {
    try {
      // Load model with updated configuration
      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/ssd_mobilenet.tflite', options: options);
      
      // Load labels
      final labelData = await rootBundle.loadString('assets/ss.txt');
      _labels = labelData.split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      print('Model loaded with ${_labels.length} labels');
    } catch (e) {
      print("Error loading model: $e");
      rethrow;
    }
  }

  Float32List preprocessImage(File imageFile, int inputWidth, int inputHeight) {
    final bytes = imageFile.readAsBytesSync();
    final image = img.decodeImage(bytes);
    
    if (image == null) throw Exception("Image decoding failed");
    
    final resizedImage = img.copyResize(image, width: inputWidth, height: inputHeight);
    final imageBuffer = Float32List(1 * inputWidth * inputHeight * 3); // Add batch dimension
    
    int bufferIndex = 0;
    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        final pixel = resizedImage.getPixel(x, y);
        imageBuffer[bufferIndex++] = pixel.r / 255.0; // Normalize to [0,1]
        imageBuffer[bufferIndex++] = pixel.g / 255.0;
        imageBuffer[bufferIndex++] = pixel.b / 255.0;
      }
    }
    return imageBuffer;
  }

  Future<String> runInference(File imageFile) async {
    // Get input tensor details
    final inputTensor = _interpreter.getInputTensors().first;
    final inputShape = inputTensor.shape;
    final inputWidth = inputShape[1];
    final inputHeight = inputShape[2];

    // Preprocess image
    final inputBuffer = preprocessImage(imageFile, inputWidth, inputHeight);

    // Prepare output buffer
    final outputTensor = _interpreter.getOutputTensors().first;
    final outputShape = outputTensor.shape;
    final outputBuffer = Float32List(outputShape.reduce((a, b) => a * b));

    // Run inference
    _interpreter.run(inputBuffer, outputBuffer);

    // Process results
    int maxIndex = 0;
    for (int i = 0; i < outputBuffer.length; i++) {
      if (outputBuffer[i] > outputBuffer[maxIndex]) {
        maxIndex = i;
      }
    }

    return _labels[maxIndex];
  }

  void dispose() {
    _interpreter.close();
  }
}