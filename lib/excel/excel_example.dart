// New widget for sharing the Excel file
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelShareButton extends StatelessWidget {
  const ExcelShareButton({Key? key}) : super(key: key);

  Future<File> _createExcelFile() async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([TextCellValue('Name'), TextCellValue('Age'), TextCellValue('Email')]);
    sheet.appendRow([TextCellValue('John Doe'), IntCellValue(23), TextCellValue('john@example.com')]);

    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/example.xlsx';
    File file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.save()!);
    return file;
  }

  Future<void> _shareExcelFile() async {
    final file = await _createExcelFile();
    Share.shareXFiles([XFile(file.path)], text: 'Here is the Excel file.');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _shareExcelFile,
      child: const Text('Excel Dosyasını Paylaş'),
    );
  }
}