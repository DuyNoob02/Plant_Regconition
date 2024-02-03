import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  const ResultScreen({Key? key, required this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả dự đoán'),
      ),
      body: Center(
        child: Text('Ket qua: $result'),
      ),
    );
  }
}
