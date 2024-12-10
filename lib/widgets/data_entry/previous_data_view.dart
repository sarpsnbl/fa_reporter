import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fa_reporter/data/mock_reports.dart';  

class PreviousDataView extends StatelessWidget {
  
  Future<File> _createExcelFile(String fileName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    
    sheet.appendRow([TextCellValue('File Name'), TextCellValue('Date')]);
    sheet.appendRow([TextCellValue(fileName), TextCellValue(DateTime.now().toString())]);

    
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/$fileName.xlsx';
    File file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.save()!);
    return file;
  }

  
  Future<void> _shareReport(String fileName) async {
    final file = await _createExcelFile(fileName);
    Share.shareXFiles([XFile(file.path)], text: 'Here is the Excel file.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Önceki Girişler"),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          var report = reports[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(report["fileName"] ?? "No Name"),
              subtitle: Text("Tarih: ${report["date"] ?? "No Date"}"),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareReport(report["fileName"]!),
              ),
            ),
          );
        },
      ),
    );
  }
}
