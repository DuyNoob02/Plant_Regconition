import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// import '';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:tflite_flutter_helper/src/tensorbuffer/tensorbufferfloat.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
// import 'dart:typed_data';

class PredictService {
  late Interpreter interpreter;
  late List<String> _labels;
  // Constructor
  PredictService() {
    _labels = [];
  }
  // final modelFileName = 'assets/ResNet50.tflite';
  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/ResNet50.tflite');
    final labelData = await rootBundle.loadString('assets/labels.txt');

    // Cập nhật _labels trước khi in ra kích thước
    _labels = labelData.split('\n');

    // debugPrint(labelData);
    debugPrint('Labels length: ${_labels.length}');
    debugPrint('Interpreter initialized successfully.');
  }

  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    // if (_labels.isEmpty) {
    //   // Nếu _labels chưa được khởi tạo, thực hiện khởi tạo
    //   await loadModel(modelFileName);
    // }

    final input = await _resizeImage(imagePath);
    // print('Input: ${input.length}');
    print('Input shape: ${interpreter.getInputTensor(0).shape}');
    // print('Input data type: ${_interpreter.getInputTensor(0).type}');
    // print('Before running interpreter... Input data: ${input.toList()}');
    print('Before running interpreter...');

    final output = Float32List(30);
    try {
      interpreter.run(input, output);
      print('After running interpreter... Output: ${output}');
    } catch (e) {
      print('Error during interpreter.run: $e');
    }
    // interpreter.run(input, output);
    print('Output shape: ${interpreter.getOutputTensor(0).shape}');
    print('Output data type: ${interpreter.getOutputTensor(0).type}');

    print('After running interpreter...');
    print('Output ${output}');

    // debugPrint('Input: ${input.toString()}');

    // debugPrint('$output[0]');

    // Lay ket qua du doan
    final List<double> predictions = output.toList();
    final int predictedIndex =
        predictions.indexOf(predictions.reduce((max, e) => max > e ? max : e));
    final double confidence = predictions[predictedIndex];
    final String predictedLabel = _labels[predictedIndex];
    debugPrint(predictedLabel);
    // Tra ve ket qua du doan
    return {
      'predictions': predictions,
      'label': predictedLabel,
      'confidence': confidence,
    };
  }

  Future<Float32List> _resizeImage(String imagePath) async {
    final Uint8List imageBytes = await File(imagePath).readAsBytes();
    final img.Image rawImage = img.decodeImage(imageBytes)!;

    // Resize the image to fit the input shape of the model [1,224,224,3]
    final img.Image resizedImage = img.copyResize(
      rawImage,
      width: 224,
      height: 224,
      interpolation: img.Interpolation.linear,
    );

    // Convert the resized image to a Float32List with normalized pixel values
    final Float32List input = Float32List(1 * 224 * 224 * 3);

    // Normalize pixel values to range from -1 to 1
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final int pixel = resizedImage.getPixel(x, y);
        input[(0 * 224 * 224 * 3) + (y * 224 * 3) + (x * 3) + 0] =
            (img.getRed(pixel) - 127.5) / 127.5;
        input[(0 * 224 * 224 * 3) + (y * 224 * 3) + (x * 3) + 1] =
            (img.getGreen(pixel) - 127.5) / 127.5;
        input[(0 * 224 * 224 * 3) + (y * 224 * 3) + (x * 3) + 2] =
            (img.getBlue(pixel) - 127.5) / 127.5;
      }
    }

    return input;
  }
}
