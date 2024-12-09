import 'dart:io';
import 'package:excel/excel.dart';
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

  List<CellValue?> entry = getRowById(excel, recognizedID);

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

void saveReport(row) async {
  excelReport = getExcelReport();
  // convert String list list to Cell list list
  List<List<CellValue?>> updatedRows = [];
  for (int i = 0; i < excelReport.length; i++) {
    updatedRows
        .add(excelReport[i].map((element) => TextCellValue(element)).toList());
  }
  writeExcelReport(updatedRows);
}

List<String> modifyExcel(column, value, data) {
  data[column] = value;

  return data;
}

List<CellValue?> getRowById(Excel excel, String id) {
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
                        wantedRow[6].value.toString()
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

void writeExcelReport(List<List<CellValue?>> rows) async {
  // Define the file path
  var outputFilePath = await getApplicationDocumentsDirectory();
  var newFilename = '/output.xlsx';
  String from = 'output';
  String replace = 'sayim' + getTollNumber() + '_' + getUserCurrentDate();
  var finalFileName = newFilename.replaceAll(from, replace);
  var file = File(outputFilePath.path + finalFileName);

  // Create or load the Excel instance
  Excel excel;
  if (file.existsSync()) {
    // Load the existing Excel file
    var bytes = file.readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  } else {
    // Create a new Excel instance
    excel = Excel.createExcel();
  }

  // Add data to the first sheet
  excel.rename("Sheet1", "Sayfa1");
  Sheet sheet = excel['Sayfa1'];

  // If the file is new, add headers
  if (!file.existsSync()) {
    sheet.appendRow(
        wantedColumns.map((toElement) => TextCellValue(toElement)).toList());
  }

  // Add the new row of data
  rows.map((row) => sheet.appendRow(row));

  // Save the file
  file.createSync(recursive: true); // Ensure the directory exists
  saveFile(excel, finalFileName);
}
