// import 'dart:io';
import 'package:detect_med_img/screens/display_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Khoi tao CameraController
    _controller = CameraController(
      const CameraDescription(
          name: '0',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0),
      ResolutionPreset.medium,
    );

    // Khoi tao Future de doi CameraController khoi tao
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // huy bo camera khi khong su dung
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chup anh'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Khi CameraController da duoc khoi tao, hien thi CameraPreview
            return CameraPreview(_controller);
          } else {
            // Khi CameraController dang khoi tao, hien thi mot tien trinh doi
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Doi CameraController khoi tao truoc khi chup anh
            await _initializeControllerFuture;
            // Tao duong dan luu tru cho anh moi
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            debugPrint(path);
            // Chup anh va luu vao duong dan da chi dinh
            XFile picture = await _controller.takePicture();
            picture.saveTo(path);

            // final File resizedImage = await _resizeImage(path);
            // Hien thi anh da chup
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayFeatureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            debugPrint(e as String?);
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
