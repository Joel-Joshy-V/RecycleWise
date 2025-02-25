import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter _interpreter;
  late List<String> _labels;

  /// Loads the TFLite model and labels.
  Future<void> loadModel() async {
    try {
      // Load the model from assets using tflite_flutter.
      _interpreter = await Interpreter.fromAsset(
        'assets/waste_classifier.tflite',
      );

      // Load labels from the labels.txt file in assets.
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels =
          labelData
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList();

      print('Model and labels loaded successfully.');
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  /// Preprocess the image:
  ///  - Decodes the image.
  ///  - Resizes to [inputWidth] x [inputHeight].
  ///  - Normalizes pixel values to [0, 1].
  ///  - Returns a Float32List representing the image data.
  Float32List preprocessImage(File imageFile, int inputWidth, int inputHeight) {
    // Read image file as bytes.
    final bytes = imageFile.readAsBytesSync();
    // Decode the image using the image package.
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception("Could not decode image.");
    }
    // Resize the image to the required dimensions.
    img.Image resizedImage = img.copyResize(
      image,
      width: inputWidth,
      height: inputHeight,
    );
    // The model expects a 1-D array of floats in the order [R, G, B, R, G, B, ...]
    Float32List imageBuffer = Float32List(inputWidth * inputHeight * 3);
    int bufferIndex = 0;
    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        var pixel = resizedImage.getPixel(x, y);
        // Extract color components.
        double r = pixel.r / 255.0;
        double g = pixel.g / 255.0;
        double b = pixel.b / 255.0;
        imageBuffer[bufferIndex++] = r;
        imageBuffer[bufferIndex++] = g;
        imageBuffer[bufferIndex++] = b;
      }
    }
    return imageBuffer;
  }

  /// Runs inference on a given image file and returns the predicted label.
  Future<String> runInference(File imageFile) async {
    // Get the input shape from the interpreter. For example: [1, 224, 224, 3]
    var inputShape = _interpreter.getInputTensor(0).shape;
    int batchSize = inputShape[0];
    int inputHeight = inputShape[1];
    int inputWidth = inputShape[2];
    int inputChannels = inputShape[3];

    // Preprocess the image.
    Float32List inputBuffer = preprocessImage(
      imageFile,
      inputWidth,
      inputHeight,
    );

    // Prepare the input in the correct shape.
    // Our model expects a tensor of shape [1, inputHeight, inputWidth, inputChannels].
    // Since our Float32List is 1D, we pass it directly (the interpreter expects a flat array if the shape is known).
    var input = inputBuffer;

    // Get the output tensor shape. For example: [1, numClasses]
    var outputShape = _interpreter.getOutputTensor(0).shape;
    int numClasses = outputShape[1];
    // Create an output buffer.
    var output = List.filled(numClasses, 0.0);

    // Run the inference.
    _interpreter.run(input, output);

    // Find the index with the highest probability.
    int predictedIndex = 0;
    double maxProb = output[0];
    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxProb) {
        maxProb = output[i];
        predictedIndex = i;
      }
    }

    // Return the corresponding label.
    return _labels[predictedIndex];
  }

  /// Closes the interpreter to free resources.
  void close() {
    _interpreter.close();
  }
}
