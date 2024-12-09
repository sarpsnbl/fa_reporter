import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fa_reporter/utils/app_directory_getset.dart';
import 'package:fa_reporter/utils/excel_getset.dart';
import 'package:fa_reporter/utils/file_load_save.dart';
import 'package:fa_reporter/utils/reports.dart';
import 'package:fa_reporter/utils/user_getset.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart'; // Ensure this is added to your `pubspec.yaml`

var id = "253030030";
var wantedColumns = [
  "Nesne",
  "Nesne Açıklaması",
  "Statü:",
  "Nesne Grubu Açıklaması",
  "GY",
  "GY Açıklama",
  "IFS Olması Gereken Lokasyon",
  "Sayım Lokasyonu",
  "Sayım Doğrulama",
  "Sayım Tarihi",
  "Sayım Numarası"
];

void main(List<String> args) {
  beginExcel(id);
}

List<String> beginExcel(recognizedID) {
  Excel excel = getAsset();

  List<TextCellValue?> entry = getRowById(excel, recognizedID);

  List<String> row = [];

  if (entry.isNotEmpty) {
    row = entry.map((cell) => cell.toString()).toList();
  } else {}

  return row;
}

Future<Excel> readExcel(String assetPath) async {
  try {
    // Load the Excel file from assets
    final byteData = await rootBundle.load(assetPath);

    // Write the file to a temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/temp_excel.xlsx';
    final tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    // Read the bytes from the temporary file and decode the Excel
    final bytes = tempFile.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    return excel;
  } catch (e) {
    print('Error reading Excel file: $e');
    rethrow;
  }
}

File saveReport() {
  List<List<String>> excelEntries = getExcelEntries();
  // convert String list list to Cell list list
  List<List<TextCellValue?>> updatedRows = [];
  for (int i = 0; i < excelEntries.length; i++) {
    updatedRows
        .add(excelEntries[i].map((element) => TextCellValue(element)).toList());
  }
  return writeExcelReport(updatedRows);
}

List<String> modifyExcel(column, value, data) {
  data[column] = value;

  return data;
}

List<TextCellValue?> getRowById(Excel excel, String id) {
  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      if (row.isNotEmpty && row[0]?.value.toString() == id) {
        List<TextCellValue> wantedRow = [];
        for (int i = 0; i < excel.tables[table]!.maxColumns; i++) {
          for (int j = 0; j < wantedColumns.length; j++) {
            if (excel.tables[table]!.rows[0][i]?.value.toString() ==
                wantedColumns[j]) {
              //wantedRow.add(TextCellValue(row[i]!.value.toString()));
              if (wantedColumns[j] == "Statü:") {
                wantedRow.insert(wantedRow.length - 1,
                    TextCellValue(row[i]!.value.toString()));
              } else {
                wantedRow.add(TextCellValue(row[i]!.value.toString()));
              }
              if (wantedColumns[wantedRow.length + 1] == "Sayım Doğrulama") {
                String value;
                value = wantedRow[6].value.toString() ==
                        wantedRow[7].value.toString()
                    ? "TRUE"
                    : "FALSE";
                wantedRow.add(TextCellValue(""));
                wantedRow.add(TextCellValue(""));
                wantedRow.insert(
                    wantedRow.length - 1, TextCellValue(value.toString()));
              }
            }
          }
        }
        wantedRow.add(TextCellValue(""));
        return wantedRow;
      }
    }
  }
  return [];
}

File writeExcelReport(List<List<TextCellValue?>> rows) {
  // Define the file path
  var outputFilePath = getAppDirectory();
  var newFilename = '/output.xlsx';
  String from = 'output';
  String replace = 'sayim' + getTollNumber() + '_' + getUserCurrentDate();
  var finalFileName = newFilename.replaceAll(from, replace);
  var file = File(outputFilePath.path + finalFileName);

  // Create or load the Excel instance
  Excel excel = Excel.createExcel();

  // Add data to the first sheet
  excel.rename("Sheet1", "Sayfa1");
  Sheet sheet = excel['Sayfa1'];

  sheet.appendRow(
      wantedColumns.map((toElement) => TextCellValue(toElement)).toList());

  for (List<TextCellValue?> row in rows) {
    sheet.appendRow(row);
  }

  for (var table in excel.sheets.keys) {
    for (var row in excel.sheets[table]!.rows) {
      for (var cell in row) {
        print(cell?.value); // Print each cell value
      }
    }
  }

  return saveFile(excel, finalFileName);
}
