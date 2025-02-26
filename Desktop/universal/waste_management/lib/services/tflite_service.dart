import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter _interpreter;
  late List<String> _labels;
  final _wasteMapping = {
    44: 'plastic',    // bottle
    47: 'paper',      // cup
    51: 'organic',    // banana
    52: 'organic',    // apple
    64: 'e-waste',    // cell phone
    72: 'e-waste',    // laptop
    75: 'e-waste',    // keyboard
    76: 'e-waste',    // cell phone
    83: 'paper',      // book
    89: 'e-waste',    // hair drier
    90: 'hygiene',    // toothbrush (index 90)
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/ssd_mobilenet.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      
      final labelData = await rootBundle.loadString('assets/ssd_mobilenet.txt');
      _labels = labelData.split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (_labels.length != 91) {
        throw Exception('Label count mismatch (${_labels.length}/91)');
      }
      print('Model loaded successfully with 91 labels');
    } catch (e) {
      print("Error loading model: $e");
      rethrow;
    }
  }

  Float32List preprocessImage(File imageFile, int inputWidth, int inputHeight) {
    final image = img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(
      image,
      width: inputWidth,
      height: inputHeight,
    );

    final imageBuffer = Float32List(1 * inputHeight * inputWidth * 3);
    
    int bufferIndex = 0;
    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        final pixel = resizedImage.getPixel(x, y);
        imageBuffer[bufferIndex++] = (pixel.r - 127.5) / 127.5;
        imageBuffer[bufferIndex++] = (pixel.g - 127.5) / 127.5;
        imageBuffer[bufferIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }
    return imageBuffer;
  }

  Future<String> runInference(File imageFile) async {
    try {
      final inputTensor = _interpreter.getInputTensor(0);
      final outputTensor = _interpreter.getOutputTensor(0);
      
      final outputLocations = List.filled(10 * 4, 0.0).reshape([1, 10, 4]);
      final outputClasses = List.filled(10, 0.0).reshape([1, 10]);
      final outputScores = List.filled(10, 0.0).reshape([1, 10]);
      final numDetections = List.filled(1, 0.0).reshape([1]);

      _interpreter.runForMultipleInputs(
        [preprocessImage(imageFile, inputTensor.shape[2], inputTensor.shape[1])],
        {0: outputLocations, 1: outputClasses, 2: outputScores, 3: numDetections},
      );

      final int numResults = numDetections[0].toInt().clamp(0, 10);
      double maxScore = 0.0;
      String label = 'No waste detected';

      for (int i = 0; i < numResults; i++) {
        final score = outputScores[0][i];
        if (score > maxScore && score > 0.4) {
          final classIndex = outputClasses[0][i].toInt();
          
          if (classIndex < 0 || classIndex >= _labels.length) {
            print('Skipping invalid index: $classIndex');
            continue;
          }
          
          maxScore = score;
          final rawLabel = _labels[classIndex];
          label = _wasteMapping[classIndex]?.toString() ?? 'General Waste ($rawLabel)';
        }
      }

      return label;
    } catch (e) {
      print("Inference error: $e");
      return 'Detection failed: ${e.toString().split(':').first}';
    }
  }

  void dispose() {
    _interpreter.close();
  }
}