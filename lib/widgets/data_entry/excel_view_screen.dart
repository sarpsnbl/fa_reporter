import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class ExcelViewScreen extends StatelessWidget {
  final File excelFile;

  const ExcelViewScreen({super.key, required this.excelFile});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<String>>>(
      future: _readExcelFile(excelFile),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Excel View"),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Excel View"),
            ),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Excel View"),
            ),
            body: const Center(child: Text("No data available")),
          );
        }

        final excelData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Excel View"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _buildColumns(excelData),
                rows: _buildRows(excelData),
              ),
            ),
          ),
        );
      },
    );
  }

  // Read Excel file and convert it to List<List<String>>
  Future<List<List<String>>> _readExcelFile(File file) async {
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);
    List<List<String>> data = [];

    for (var table in excel.tables.values) {
      for (var row in table.rows) {
        data.add(row.map((cell) => cell?.value?.toString() ?? "").toList());
      }
    }
    return data;
  }

  // Builds the columns from the first row of the matrix
  List<DataColumn> _buildColumns(List<List<String>> data) {
    return List.generate(data[0].length, (index) {
      return DataColumn(label: Text("Column ${index + 1}"));
    });
  }

  // Builds the rows from the matrix data
  List<DataRow> _buildRows(List<List<String>> data) {
    return List.generate(data.length, (rowIndex) {
      return DataRow(
        cells: List.generate(
          data[rowIndex].length,
          (colIndex) => DataCell(Text(data[rowIndex][colIndex])),
        ),
      );
    });
  }
}
