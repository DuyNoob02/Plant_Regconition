import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class PredictService {
  late Interpreter _interpreter;
  late List<String> _labels;
  // Constructor
  PredictService() {
    _labels = [];
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/ResNet50.tflite');
    final labelData = await rootBundle.loadString('assets/labels.txt');

    // Cập nhật _labels trước khi in ra kích thước
    _labels = labelData.split('\n');

    // debugPrint(labelData);
    debugPrint('Labels length: ${_labels.length}');
    debugPrint('Interpreter initialized successfully.');
  }

  Future<Map<String, dynamic>> predictImage(String imagePath) async {
    if (_labels.isEmpty) {
      // Nếu _labels chưa được khởi tạo, thực hiện khởi tạo
      await loadModel();
    }

    // final resizedImageFile = await _resizeImage(imagePath);
    // final resizedBytes = await resizedImageFile.readAsBytes();
    // final input = Uint8List.fromList(resizedBytes);
    final input = await _resizeImage(imagePath);
    print('Input: ${input}');
    print('Input shape: ${_interpreter.getInputTensor(0).shape}');
    print('Input data type: ${_interpreter.getInputTensor(0).type}');
    // print('Before running interpreter... Input data: ${input.toList()}');
    print('Before running interpreter...');
    // final output = List.generate(
    //   1,
    //   (index) => Float32List.fromList(List.filled(_labels.length, 0.0)),
    // );
    final output = Float32List(_labels.length);
    try {
      _interpreter.run(input, [output]);
      // final convertedOutput = Float32List.fromList(output[0]);
      print('After running interpreter... Output: ${output}');
      // print('After running interpreter... Output: ${output}');
    } catch (e) {
      print('Error during interpreter.run: $e');
    }
    // _interpreter.run(input, output);
    print('Output shape: ${_interpreter.getOutputTensor(0).shape}');
    // print('Output data type: ${_interpreter.getOutputTensor(0).type}');

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
    final imageFile = File(imagePath);
    final img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
    final img.Image resizedImage =
        img.copyResize(image, width: 224, height: 224);

    Float32List imageTensor = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        double normalizedRed = img.getRed(pixel) / 255.0;
        double normalizedGreen = img.getGreen(pixel) / 255.0;
        double normalizedBlue = img.getBlue(pixel) / 255.0;

        imageTensor[pixelIndex++] = normalizedRed;
        imageTensor[pixelIndex++] = normalizedGreen;
        imageTensor[pixelIndex++] = normalizedBlue;
      }
    }

    // Kiểm tra kích thước của tensor
    assert(pixelIndex == 1 * 224 * 224 * 3);

    return imageTensor;
  }
}
