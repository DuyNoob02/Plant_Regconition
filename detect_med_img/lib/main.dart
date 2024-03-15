// import 'dart:typed_data';

import 'dart:convert';

import 'package:detect_med_img/screens/display_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:async';
import 'package:detect_med_img/screens/camera_screen.dart';
import 'package:http/http.dart' as http;
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String searchQuery;
  late bool showPlantInfo;
  late Map<String, dynamic> plantInfo;
  @override
  void initState() {
    super.initState();
    searchQuery = '';
    showPlantInfo = false;
    plantInfo = {};
  }

  Future<void> searchPlant(String searchQuery) async {
    final url = Uri.parse(
        'http://192.168.128.104:8008/plant/search/query?query=$searchQuery');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          plantInfo = responseData;
          showPlantInfo = true;
        });
        print(responseData);
      } else {
        throw Exception('Fail to load plant infomation');
      }
    } catch (e) {
      print('Error fetching plant information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhận dạng cây thuốc Nam'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Nhập tên cây...',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    searchPlant(searchQuery);
                  },
                  child: const Text('Tìm kiếm'),
                ),
              ],
            ),
          ),
          // Padding(

          // ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CameraScreen()),
                  );
                },
                child: const Text('Chụp ảnh mới'),
              ),
              // const SizedBox(height: 1000),
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
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
            child: showPlantInfo
                ? PlantInfoWidget(plantInfo: plantInfo)
                : Container(),
          ))
        ],
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
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Tên cây: ${plantInfo['result'][0]['name']}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tên khoa học: ${plantInfo['result'][0]['scientificName']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Hình ảnh minh họa:',
              style: const TextStyle(fontSize: 20),
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
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                'Mô tả',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${plantInfo['result'][0]['description']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                'Thông tin dược liệu',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${plantInfo['result'][0]['info']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
