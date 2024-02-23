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
  late List<CameraDescription> cameras;
  bool isReady = false;
  @override
  void initState() {
    super.initState();
    // setupCameras();
    _initializeControllerFuture = setupCameras();
    // Khoi tao CameraController
    // _controller = new CameraController(
    //   const CameraDescription(
    //       name: '0',
    //       lensDirection: CameraLensDirection.back,
    //       sensorOrientation: 0),
    //   ResolutionPreset.medium,
    //   imageFormatGroup: ImageFormatGroup.yuv420,
    // );
    // _controller = new CameraController(
    //   cameras[0],
    //   ResolutionPreset.medium,
    //   imageFormatGroup: ImageFormatGroup.yuv420,
    // );
    // // Khoi tao Future de doi CameraController khoi tao
    // _initializeControllerFuture = _controller.initialize();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[0],
          ResolutionPreset.medium,
          imageFormatGroup: ImageFormatGroup.yuv420,
        );
        await _controller.initialize();
        // _initializeControllerFuture = _controller.initialize();
        setState(() {
          isReady = true;
        });
        print("Camera is ready");
      } else {
        // print('loi o day');
        print("No cameras found");
        setState(() {
          isReady = false;
        });
      }
    } on CameraException catch (e) {
      print("Error initializing camera: $e");
      setState(() {
        isReady = false;
      });
    }
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
        title: const Text('Chụp ảnh'),
      ),
      // body: isReady
      //     ? CameraPreview(_controller)
      //     : Center(child: const CircularProgressIndicator()),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview.
            return isReady
                ? CameraPreview(_controller)
                : Center(child: const CircularProgressIndicator());
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isReady
            ? () async {
                try {
                  await _initializeControllerFuture;
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );
                  XFile picture = await _controller.takePicture();
                  picture.saveTo(path);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DisplayFeatureScreen(imagePath: path),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              }
            : null,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Chup anh'),
  //     ),
  //     body: FutureBuilder<void>(
  //       future: _initializeControllerFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           // Khi CameraController da duoc khoi tao, hien thi CameraPreview
  //           return CameraPreview(_controller);
  //         } else {
  //           // Khi CameraController dang khoi tao, hien thi mot tien trinh doi
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () async {
  //         try {
  //           // Doi CameraController khoi tao truoc khi chup anh
  //           await _initializeControllerFuture;
  //           // Tao duong dan luu tru cho anh moi
  //           final path = join(
  //             (await getTemporaryDirectory()).path,
  //             '${DateTime.now()}.png',
  //           );
  //           debugPrint(path);
  //           // Chup anh va luu vao duong dan da chi dinh
  //           XFile picture = await _controller.takePicture();
  //           picture.saveTo(path);

  //           // final File resizedImage = await _resizeImage(path);
  //           // Hien thi anh da chup
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => DisplayFeatureScreen(imagePath: path),
  //             ),
  //           );
  //         } catch (e) {
  //           print(e);
  //         }
  //       },
  //       child: const Icon(Icons.camera),
  //     ),
  //   );
  // }
// }
