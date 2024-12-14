import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

// ignore: prefer_typing_uninitialized_variables
var cachedData;

// Asynchronous method to preload the asset
Future<void> preloadAsset(String assetPath) async {
  // Load the file as bytes
  final ByteData data = await rootBundle.load('assets/data.xlsx');
  final List<int> bytes = data.buffer.asUint8List();

  // Decode the Excel file
  cachedData = Excel.decodeBytes(Uint8List.fromList(bytes));
}

// Synchronous method to retrieve the preloaded asset
Excel getAsset() {
  if (cachedData == null) {
    throw Exception("Asset not preloaded. Call preloadAsset() first.");
  }
  return cachedData!;
}
