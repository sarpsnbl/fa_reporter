import 'dart:io';
import 'package:excel/excel.dart';

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

void main() async {
  var filePath = 'excel test\\excel_processor\\lib\\Arge Sayım Data v.1.xlsx';
  var excel = readExcel(filePath);

  List<CellValue?> entry = getRowById(excel, id);
  List<CellValue?> updatedRow = [];

  List<String> row = [];
  if (entry.isNotEmpty) {
    row = entry.map((cell) => cell.toString()).toList();
  } else {
    print('Row with ID $id not found.');
  }

  updatedRow = row.map((toElement) => TextCellValue(toElement)).toList();

  addToExcelReport(updatedRow);

  print('Excel processing completed.');
}

Excel readExcel(String filePath) {
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  return excel;
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

void addToExcelReport(List<CellValue?> row) {
  // Define the file path
  String outputFilePath = 'excel test/excel_processor/lib/output.xlsx';
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
  sheet.appendRow(row);

  // Save the file
  file.createSync(recursive: true); // Ensure the directory exists
  var fileBytes = excel.save();

  if (fileBytes != null) {
    File('excel test\\excel_processor\\lib\\output.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }

  print('Excel file updated at $outputFilePath');
}
