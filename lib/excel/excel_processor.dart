import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fa_reporter/utils/user_getset.dart';

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
  var filePath = 'excel test\\excel_processor\\lib\\Arge Sayım Data v.1.xlsx';
  var excel = readExcel(filePath);

  List<CellValue?> entry = getRowById(excel, recognizedID);

  List<String> row = [];
  if (entry.isNotEmpty) {
    row = entry.map((cell) => cell.toString()).toList();
  } else {}

  return row;
}

Excel readExcel(String filePath) {
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  return excel;
}

void saveReport(row) {
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
              wantedRow.add(TextCellValue(row[i]!.value.toString()));
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
        return wantedRow;
      }
    }
  }
  return [];
}

void writeExcelReport(List<List<CellValue?>> rows) {
  // Define the file path
  String outputFilePath = 'excel test/excel_processor/lib/output.xlsx';
  var newfilepath = "";
  //replace output file path with new file path
  String from = 'output';
  String replace = 'sayim' + getTollNumber() + '_' + getUserCurrentDate();
  outputFilePath = outputFilePath.replaceAll(from, replace);
  var file = File(outputFilePath);

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
  var fileBytes = excel.save();

  if (fileBytes != null) {
    File('excel test\\excel_processor\\lib\\output.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }
}
