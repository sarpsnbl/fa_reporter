import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

var _cachedAsset;

// Asynchronous method to preload the asset
Future<void> preloadAsset(String assetPath) async {
  print("########################################################");
  // Load the file as bytes
  final ByteData data = await rootBundle.load('assets/data.xlsx');
  final List<int> bytes = data.buffer.asUint8List();

  // Decode the Excel file
  _cachedAsset = Excel.decodeBytes(Uint8List.fromList(bytes));

  if (_cachedAsset != null) {
    print('Excel loaded successfully');
  } else {
    print('Failed to load Excel file');
  }
}


// Synchronous method to retrieve the preloaded asset
Excel getAsset() {
  if (_cachedAsset == null) {
    throw Exception("Asset not preloaded. Call preloadAsset() first.");
  }
  return _cachedAsset!;
}