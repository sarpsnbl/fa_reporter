import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fa_reporter/utils/app_directory_getset.dart';
import 'package:fa_reporter/utils/excel_getset.dart';
import 'package:fa_reporter/utils/file_load_save.dart';
import 'package:fa_reporter/utils/user_getset.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

var id = "253030040";
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

File saveReport() {
  List<List<String>> excelEntries = getExcelEntries();

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
              if (wantedColumns[j] == "Statü:") {
                wantedRow.insert(wantedRow.length - 1,
                    TextCellValue(row[i]!.value.toString()));
              } else {
                wantedRow.add(TextCellValue(row[i]!.value.toString()));
              }
              if (wantedColumns[wantedRow.length + 1] == "Sayım Doğrulama") {
                String value;
                value = wantedRow[6].value.toString() == getUserLocation()
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
  var newFilename = '/output.xlsx';
  String from = 'output';
  String replace = 'sayim' + getTollNumber() + '_' + getUserCurrentDate();
  var finalFileName = newFilename.replaceAll(from, replace);

  Excel excel = Excel.createExcel();

  excel.rename("Sheet1", "Sayfa1");
  Sheet sheet = excel['Sayfa1'];

  sheet.appendRow(
      wantedColumns.map((toElement) => TextCellValue(toElement)).toList());

  for (List<TextCellValue?> row in rows) {
    sheet.appendRow(row);
  }

  return saveFile(excel, finalFileName);
}
