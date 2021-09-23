import 'package:flutter/material.dart';
import 'package:handy/helpers/safe_function.dart';
import 'package:handy/models/handy_file.dart';
import 'package:handy/pages/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'components/expandible_fab.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();
  List<HandyFile> _fileArr = [];

  Future<void> storeFile(XFile? file) async {
    if (file != null) {
      final pickedFilePieces = file.path.split('/');
      final newImgName = pickedFilePieces[pickedFilePieces.length - 1];

      final Directory dir = await getApplicationDocumentsDirectory();
      final path = dir.path;

      final imgPath = '$path/$newImgName';

      await file.saveTo(imgPath);

      final newFile = HandyFile('image', imgPath);

      setState(() {
        _fileArr.add(newFile);
      });
    }
  }

  void pickFile(ImageSource source) {
    SafeFunction(() async {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      await storeFile(pickedFile);
    }, context)
        .run();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handy Files"),
      ),
      body: Center(child: imageList()),
      floatingActionButton: ExpandableFab(
        distance: 70.0,
        children: [
          FABActionButton(
            onPressed: () => pickFile(ImageSource.gallery),
            icon: const Icon(Icons.file_copy_sharp),
          ),
          FABActionButton(
            onPressed: () => pickFile(ImageSource.camera),
            icon: const Icon(Icons.insert_photo),
          )
        ],
      ),
    );
  }

  Widget imageList() {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: _fileArr.map((HandyFile file) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: renderFile(file),
            color: Colors.teal[100],
          );
        }).toList());
  }

  Widget renderFile(HandyFile file) {
    switch (file.kind) {
      case 'image':
        return TextButton(
            child: Image.file(File(file.path)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImagePreview(
                          imgPath: file.path,
                        )),
              );
            });
      default:
        return const Text("Kind not supported");
    }
  }
}
