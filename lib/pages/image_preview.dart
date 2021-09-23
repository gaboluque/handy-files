import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  final String imgPath;

  const ImagePreview({Key? key, required this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: FileImage(File(imgPath)),
    );
  }
}
