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

/// Loads and returns a list of files from the application documents directory.
/// 
/// This function retrieves the application documents directory, lists all
/// entities within it, filters to include only files, and returns them as
/// a list of `File` objects.
/// 
/// Returns:
///   A `Future` that completes with a list of files present in the 
///   application documents directory.

Future<List<File>> loadFilesFromDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory
      .listSync()
      .where((file) => file is File && file.path.endsWith('.xlsx'))
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
