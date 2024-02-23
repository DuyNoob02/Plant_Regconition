// import 'package:flutter/material.dart';

// class ResultScreen extends StatelessWidget {
//   final Map<String, dynamic> result;

//   const ResultScreen({Key? key, required this.result}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Extract label and probability from the result map
//     String predictedLabel = result['class_label'];
//     double predictedProbability =
//         result['predictions'][0][result['class_label']];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kết quả dự đoán'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Nhãn dự đoán: $predictedLabel',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Xác suất dự đoán: ${(predictedProbability * 100).toStringAsFixed(2)}%',
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class ResultScreen extends StatelessWidget {
//   final Map<String, dynamic> result;

//   const ResultScreen({Key? key, required this.result}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final label = result['class_label'];
//     final confidence =
//         (result['predictions'][0][result['class_label'].indexOf(label)] * 100)
//             .toStringAsFixed(2);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Result'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Predicted Label: $label',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Confidence: $confidence%',
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách dự đoán từ kết quả
    List<double> predictions = result['predictions'][0].cast<double>();

    // Tìm giá trị lớn nhất trong danh sách dự đoán
    double maxPrediction = predictions
        .reduce((value, element) => value > element ? value : element);

    // Lấy vị trí của giá trị lớn nhất trong danh sách dự đoán
    // int maxIndex = predictions.indexOf(maxPrediction);

    // Lấy nhãn tương ứng với vị trí
    String classLabel = result['class_label'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả dự đoán'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nhãn: $classLabel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Độ chính xác: ${(maxPrediction * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
