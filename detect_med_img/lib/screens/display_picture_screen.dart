import 'package:detect_med_img/screens/result_screen.dart';
import 'package:detect_med_img/service/predict.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class DisplayFeatureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayFeatureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<DisplayFeatureScreen> createState() => _DisplayFeatureScreenState();
}

class _DisplayFeatureScreenState extends State<DisplayFeatureScreen> {
  late PredictService _predictService;
  late bool _isPredicting = false;
  late Map<String, dynamic> _predictionResult;
  late File _imageFile;

  @override
  void initState() {
    super.initState();
    // _predictService = PredictService();
    // _predictService.loadModel();
    _initializePredictService();
    _predictionResult = {};
    _imageFile = File(widget.imagePath);
  }

  Future<void> _initializePredictService() async {
    _predictService = PredictService();
    await _predictService.loadModel();
  }
  // Futer

  Future<void> _onCheckPressed() async {
    setState(() {
      _isPredicting = true;
    });

    try {
      // final rawBytes = await _imageFile.readAsBytes();
      // Goi predict khi check
      var result = await _predictService.predictImage(_imageFile.path);
      debugPrint(_imageFile.path);
      setState(() {
        _predictionResult = result;
        _isPredicting = false;
      });

      // Chuyển đến trang kết quả
      final navigator = Navigator.of(context);
      navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: _predictionResult),
        ),
      );
    } catch (e) {
      // Xu ly loi neu co
      setState(() {
        _isPredicting = false;
      });
      debugPrint('Error predicting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(widget.imagePath)),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleIconButton(
                  icon: Icons.cancel,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CircleIconButton(
                  icon: Icons.check,
                  color: Colors.green,
                  onPressed: () => _onCheckPressed(),
                ),
              ],
            ),
          ),
          if (_isPredicting) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const CircleIconButton({
    Key? key,
    required this.icon,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
