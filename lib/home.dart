import 'package:flutter/material.dart';
import 'package:handy/components/file_list.dart';
import 'package:handy/helpers/safe_function.dart';
import 'package:handy/models/handy_file.dart';
import 'package:handy/repos/handy_files_repo.dart';
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

  @override
  void initState() {
    super.initState();
    loadFileList();
  }

  void loadFileList() async {
    final newList = await HandyFilesRepo.getAllHandyFiles();

    setState(() {
      _fileArr = newList;
    });
  }

  Future<void> storeFile(XFile? file) async {
    if (file != null) {
      final pickedFilePieces = file.path.split('/');
      final newImgName = pickedFilePieces[pickedFilePieces.length - 1];

      final Directory dir = await getApplicationDocumentsDirectory();
      final path = dir.path;

      final imgPath = '$path/$newImgName';

      await file.saveTo(imgPath);

      final newFile = await HandyFile(kind: 'image', path: imgPath).save();

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

  void deleteFile(HandyFile file) async {
    await HandyFilesRepo.deleteHandyFileWithId(file.id!);
    loadFileList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handy Files"),
      ),
      body: Center(
          child: FileList(
        fileList: _fileArr,
        onDeleteFile: deleteFile,
      )),
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
}
