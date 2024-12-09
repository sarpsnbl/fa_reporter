import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fa_reporter/utils/app_directory_getset.dart';
import 'package:path_provider/path_provider.dart';

var files;

getFiles() {
  return files;
}

setFiles(newFiles) {
  files = newFiles;
}

Future<List<File>> loadFilesFromDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory
      .listSync()
      .where((file) => file is File)
      .cast<File>()
      .toList();
}

File saveFile(Excel excel, filename) {
  var path = getAppDirectory();
  var fileBytes = excel.save();
  var finalFile;

  if (fileBytes != null) {
    finalFile = File(path.path + filename)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
    files.add(finalFile);
  }

  return finalFile;
}
