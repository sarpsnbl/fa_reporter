import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ExcelShareButton extends StatelessWidget {
  final File file;

  const ExcelShareButton({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => shareExcelFile(file), // Parametre ile çağır
      child: const Text('Excel Dosyasını Paylaş'),
    );
  }
}

Future<void> shareExcelFile(File file) async {
  Share.shareXFiles([XFile(file.path)], text: 'Son Sayım.');
}
