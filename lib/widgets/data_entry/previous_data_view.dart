import 'dart:io';
import 'package:fa_reporter/excel/excel_share.dart';
import 'package:fa_reporter/utils/file_load_save.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fa_reporter/data/mock_reports.dart';  

class PreviousDataView extends StatelessWidget {
  
  var reports = getFiles();

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
              title: Text(parsePath(report.path).$1 ?? "No Name"),
              subtitle: Text("Tarih: ${parsePath(report.path).$2 ?? "No Date"}"),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () => shareExcelFile(report),
              ),
            ),
          );
        },
      ),
    );
  }
}

(String, String) parsePath(String path) {
  // Extract the part after the last '/' and before the last '.'
  final RegExp regex = RegExp(r'\/([^\/]+)\.[^\.]+$');
  final match = regex.firstMatch(path);

  if (match != null) {
    String partAfterLastSlash = match.group(1) ?? '';
    // Find the part after the last `_` and before the last `.`
    int lastUnderscoreIndex = partAfterLastSlash.lastIndexOf('_');
    String partAfterLastUnderscore = lastUnderscoreIndex != -1
        ? partAfterLastSlash.substring(lastUnderscoreIndex + 1)
        : '';

    return (partAfterLastSlash, partAfterLastUnderscore);
  }
  
  return ('', '');
}

