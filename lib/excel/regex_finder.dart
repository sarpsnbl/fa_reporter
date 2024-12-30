import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  // Load the Excel file
  var file = "assets\\data.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  // Assuming the data is in the first sheet
  var sheet = excel.tables[excel.tables.keys.first]!;

  // Set to store unique formats
  Set<String> uniqueFormats = {};

  // Function to detect the format
  String detectFormat(String id) {
    return id.split('').map((char) {
      if (RegExp(r'[A-Za-z]').hasMatch(char)) {
        return 'L'; // Letter
      } else if (RegExp(r'\d').hasMatch(char)) {
        return 'N'; // Number
      } else {
        return char; // Keep special characters
      }
    }).join('');
  }

  // Process each row
  for (var i = 1; i < sheet.maxRows; i++) { // Skip header row (assumed row 0)
    var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i));
    var id = cell.value?.toString() ?? '';

    if (id.isNotEmpty) {
      uniqueFormats.add(detectFormat(id));
    }
  }

  // Print all unique formats
  print("Unique ID Formats:");
  for (var format in uniqueFormats) {
    print(format);
  }
}
