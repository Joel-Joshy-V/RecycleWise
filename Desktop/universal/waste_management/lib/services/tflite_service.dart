import 'dart:io';
import 'package:flutter/foundation.dart';
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
    90: 'hygiene',    // toothbrush
  };

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/ssd_mobilenet.tflite',
        options: InterpreterOptions()
          ..threads = 4
          ..useNnApiForAndroid = true,
      );
      
      final labelData = await rootBundle.loadString('assets/ssd_mobilenet.txt');
      _labels = labelData.split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
          
      if (_labels.length != 91) {
        throw Exception('Label file must contain exactly 91 entries');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Model initialization error: $e");
      }
      rethrow;
    }
  }

  Float32List _preprocessImage(File imageFile, int inputWidth, int inputHeight) {
    final image = img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(image, width: inputWidth, height: inputHeight);

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
      final outputTensors = _interpreter.getOutputTensors();

      // 1. Verify output tensor indices dynamically
      final boxesIndex = outputTensors.indexWhere((t) => t.shape.toString() == '[1, 10, 4]');
      final classesIndex = outputTensors.indexWhere((t) => t.shape.toString() == '[1, 10]');
      final scoresIndex = outputTensors.indexWhere((t) => t.shape.toString() == '[1, 10]');
      final countIndex = outputTensors.indexWhere((t) => t.shape.toString() == '[1, 1]');

      if (boxesIndex == -1 || classesIndex == -1 || scoresIndex == -1 || countIndex == -1) {
        throw Exception('Invalid model output structure');
      }

      // 2. Initialize outputs with verified dimensions
      final outputBoxes = List.filled(10 * 4, 0.0).reshape([1, 10, 4]);
      final outputClasses = List.filled(10, 0.0).reshape([1, 10]);
      final outputScores = List.filled(10, 0.0).reshape([1, 10]);
      final outputCount = List.filled(1, 0.0).reshape([1, 1]);

      _interpreter.runForMultipleInputs(
        [_preprocessImage(imageFile, inputTensor.shape[2], inputTensor.shape[1])],
        {
          boxesIndex: outputBoxes,
          classesIndex: outputClasses,
          scoresIndex: outputScores,
          countIndex: outputCount,
        },
      );

      // 3. Safe value extraction with null checks
      final numDetections = outputCount.isNotEmpty && 
                          outputCount[0].isNotEmpty
          ? outputCount[0][0].toInt().clamp(0, 10)
          : 0;

      double maxScore = 0.0;
      String label = 'No waste detected';

      for (int i = 0; i < numDetections; i++) {
        // Prevent index overflow
        if (i >= outputScores[0].length || i >= outputClasses[0].length) break;

        final score = outputScores[0][i];
        final classId = outputClasses[0][i].toInt();

        if (score > maxScore && score > 0.4) {
          if (classId >= 0 && classId < _labels.length) {
            maxScore = score;
            label = _wasteMapping[classId] ?? 'General Waste (${_labels[classId]})';
          } else {
            debugPrint('Skipping invalid class ID: $classId');
          }
        }
      }

      return label;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Inference error: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      return 'Detection failed';
    }
  }

  void dispose() {
    _interpreter.close();
  }
}