import 'package:fa_reporter/widgets/data_entry/end_inventory_counting_view.dart';
import 'package:fa_reporter/widgets/data_entry/previous_entries_view.dart'; // Import your new view here
import 'package:fa_reporter/widgets/ocr/text_detector_view.dart';
import 'package:flutter/material.dart';

class EntryConfirmationPopup extends StatelessWidget {
  final String recognizedID;

  const EntryConfirmationPopup({required this.recognizedID, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kaydedildi'),
      content: Text('Nesne "$recognizedID" kaydedildi.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TextRecognizerView()),
            );
          },
          child: const Text('Sonraki Demirbaşı Tara'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const PreviousEntriesView()), // Navigate to PreviousEntriesView
            );
          },
          child: const Text('Önceki Tarananları Gör'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EndInventoryCountingView()),
            );
          },
          child: const Text('Sayımı Bitir'),
        ),
      ],
    );
  }
}