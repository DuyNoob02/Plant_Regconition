// import 'dart:typed_data';

import 'package:detect_med_img/screens/display_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:async';
import 'package:detect_med_img/screens/camera_screen.dart';

// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MedApp',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhận dạng cây thuốc Nam'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );
            },
            child: const Text('Chụp ảnh mới'),
          ),
          const SizedBox(height: 1000),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                // final File resizedImage = await _resizeImage(pickedFile.path);
                // Luu tru context hien tai
                // BuildContext currentContext = context;
                // Hien thi anh da chon
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        DisplayFeatureScreen(imagePath: pickedFile.path),
                  ),
                );
              } else {
                debugPrint('No image selected.');
              }
            },
            child: const Text('Chọn ảnh từ thiết bị'),
          ),
        ],
      ),
    );
  }
}
