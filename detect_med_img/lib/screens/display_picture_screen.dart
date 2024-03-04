import 'package:detect_med_img/screens/result_screen.dart';
// import 'package:detect_med_img/service/predict.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class DisplayFeatureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayFeatureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<DisplayFeatureScreen> createState() => _DisplayFeatureScreenState();
}

class _DisplayFeatureScreenState extends State<DisplayFeatureScreen> {
  // late PredictService _predictService;
  late bool _isPredicting = false;
  // late Map<String, dynamic> _predictionResult;

  Future<void> _onCheckPressed(BuildContext context) async {
    setState(() {
      _isPredicting = true;
    });

    try {
      var uri = Uri.parse('http://192.168.1.50:5000/predict');
      var request = http.MultipartRequest('POST', uri);
      request.files
          .add(await http.MultipartFile.fromPath('image', widget.imagePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var result = json.decode(jsonResponse);

        setState(() {
          _isPredicting = false;
        });
        print(result);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      } else {
        setState(() {
          _isPredicting = false;
        });
        print('Failed to get prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isPredicting = false;
      });
      print('Error predicting: $e');
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
                  onPressed: () => _onCheckPressed(context),
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
