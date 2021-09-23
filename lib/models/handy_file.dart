import 'dart:async';

import 'package:handy/repos/handy_files_repo.dart';

class HandyFile {
  String kind;
  String path;
  int? id;

  HandyFile({this.id, required this.kind, required this.path});

  Future<HandyFile> save() async {
    var newId = await HandyFilesRepo.addHandyFileToDatabase(this);
    id = newId;

    return this;
  }

  factory HandyFile.fromMap(Map<String, dynamic> json) =>
      HandyFile(id: json['id'], kind: json['kind'], path: json['path']);

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "path": path,
      };
}
