import 'package:fa_reporter/excel/excel_share.dart';
import 'package:fa_reporter/utils/file_load_save.dart';
import 'package:fa_reporter/widgets/data_entry/excel_view_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PreviousDataView extends StatelessWidget {
  
  var reports = getFiles();

  PreviousDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Önceki Girişler"),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          var report = reports[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ExcelViewScreen(excelFile: report,)),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parsePath(report.path).$1,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Tarih: ${parsePath(report.path).$2}"),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => shareExcelFile(report),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

(String, String) parsePath(String path) {
  final RegExp regex = RegExp(r'\/([^\/]+)\.[^\.]+$');
  final match = regex.firstMatch(path);

  if (match != null) {
    String partAfterLastSlash = match.group(1) ?? '';
    int lastUnderscoreIndex = partAfterLastSlash.lastIndexOf('_');
    String partAfterLastUnderscore = lastUnderscoreIndex != -1
        ? partAfterLastSlash.substring(lastUnderscoreIndex + 1)
        : '';

    return (partAfterLastSlash, partAfterLastUnderscore);
  }

  return ('', '');
}
