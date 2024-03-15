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

// class ResultScreen extends StatelessWidget {
//   final Map<String, dynamic> result;

//   const ResultScreen({Key? key, required this.result}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Lấy danh sách dự đoán từ kết quả
//     List<double> predictions = result['predictions'][0].cast<double>();

//     // Tìm giá trị lớn nhất trong danh sách dự đoán
//     double maxPrediction = predictions
//         .reduce((value, element) => value > element ? value : element);

//     // Lấy vị trí của giá trị lớn nhất trong danh sách dự đoán
//     // int maxIndex = predictions.indexOf(maxPrediction);

//     // Lấy nhãn tương ứng với vị trí
//     String classLabel = result['class_label'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Kết quả dự đoán'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Nhãn: $classLabel',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Độ chính xác: ${(maxPrediction * 100).toStringAsFixed(2)}%',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  const ResultScreen({Key? key, required this.result}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<Map<String, dynamic>> plantInfo;

  @override
  void initState() {
    super.initState();
    plantInfo = fetchPlantInfo(widget.result['class_label']);
  }

  Future<Map<String, dynamic>> fetchPlantInfo(String classLabel) async {
    print("Nhan la ${classLabel}");
    final response = await http.get(
      Uri.parse(
          // 'http://127.0.0.1:8008/plant/getPlantInfor/query?code=$classLabel'),
          'http://192.168.128.104:8008/plant/getPlantInfor/query?code=$classLabel'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      // return jsonDecode(response.body)['result'];
      if (data.isNotEmpty) {
        return data;
      } else {
        throw Exception('Plant info not found');
      }
    } else {
      throw Exception('Failed to load plant info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả dự đoán'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: plantInfo,
        builder: (context, snapshot) {
          print('snapshot ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi: ${snapshot.error}');
          } else {
            return PlantInfoWidget(plantInfo: snapshot.data!);
          }
        },
      ),
    );
  }
}

class PlantInfoWidget extends StatelessWidget {
  final Map<String, dynamic> plantInfo;
  const PlantInfoWidget({Key? key, required this.plantInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Tên cây: ${plantInfo['result'][0]['name']}',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tên khoa học: ${plantInfo['result'][0]['scientificName']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Hình ảnh minh họa:',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  plantInfo['result'][0]['images'].map<Widget>((imageUrl) {
                return Image.network(imageUrl);
              }).toList(),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Mô tả',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${plantInfo['result'][0]['description']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Thông tin dược liệu',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${plantInfo['result'][0]['info']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
