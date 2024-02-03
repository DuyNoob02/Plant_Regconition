// import 'package:tflite/tflite.dart';

// class TFLiteHelper {
//   static Future<void> loadModel() async {
//     await Tflite.loadModel(
//       model: 'assets/ResNet50.tflite',
//       labels: 'assets/labels.txt',
//     );
//   }

//   static Future<List?> runModelOnImage(String imagePath) async {
//     return await Tflite.runModelOnImage(
//       path: imagePath,
//       imageMean: 0.0,
//       imageStd: 255.0,
//       numResults: 1,
//       threshold: 0.2,
//     );
//   }

//   static Future<void> closeModel() async {
//     await Tflite.close();
//   }
// }
