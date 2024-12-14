//function to convert excel to ListListString in dart
import 'package:excel/excel.dart';

List<List<String>> excelToMatrix(Excel excel) {
  List<List<String>> matrix = [];
  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      List<String> temp = [];
      for (int i = 0; i < excel.tables[table]!.maxColumns; i++) {
        temp.add(row[i]!.value.toString());
      }
      matrix.add(temp);
    }
  }
  return matrix;
}
