import 'package:flutter/material.dart';
import 'package:handy/models/handy_file.dart';
import 'package:handy/pages/image_preview.dart';
import 'dart:io';

class FileList extends StatelessWidget {
  final List<HandyFile> fileList;
  final Function onDeleteFile;

  const FileList({Key? key, required this.fileList, required this.onDeleteFile})
      : super(key: key);

  confirmDelete(HandyFile file, BuildContext ctx) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        onDeleteFile(file);
        Navigator.of(ctx).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Atention!"),
      content: const Text("This file will be deleted!"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget renderFile(HandyFile file) {
    switch (file.kind) {
      case 'image':
        return FittedBox(
          child: Image.file(File(file.path)),
          fit: BoxFit.fill,
        );
      default:
        return const Text("Kind not supported");
    }
  }

  void openFile(HandyFile file, BuildContext ctx) {
    switch (file.kind) {
      case 'image':
        Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (context) => ImagePreview(imgPath: file.path)),
        );
        break;
      default:
        break;
    }
  }

  Widget renderFileContainer(HandyFile file, BuildContext ctx) {
    return GestureDetector(
      onLongPress: () => confirmDelete(file, ctx),
      onTapUp: (TapUpDetails d) {
        openFile(file, ctx);
      },
      child: renderFile(file),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: fileList.map((HandyFile file) {
          return Container(
            child: renderFileContainer(file, context),
          );
        }).toList());
  }
}
