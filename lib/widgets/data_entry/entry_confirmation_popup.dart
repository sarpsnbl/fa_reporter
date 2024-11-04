import 'package:fa_reporter/widgets/data_entry/end_inventory_counting_view.dart';
import 'package:fa_reporter/widgets/data_entry/previous_data_view.dart';
import 'package:fa_reporter/widgets/ocr/text_detector_view.dart';
import 'package:flutter/material.dart';

class EntryConfirmationPopup extends StatelessWidget {
  final String recognizedID;

  const EntryConfirmationPopup({required this.recognizedID, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Kaydedildi'),
      content: Text('Nesne "$recognizedID" kaydedildi.'),
      actions: [
        TextButton(
          onPressed: () {
            // Handle "Sonraki Demirbaşı Tara" action
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => TextRecognizerView()),
            );
          },
          child: Text('Sonraki Demirbaşı Tara'),
        ),
        TextButton(
          onPressed: () {
            // Handle "Öncekileri Gör" action
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => PreviousDataView()),
            );
          },
          child: Text('Öncekileri Gör'),
        ),
        TextButton(
          onPressed: () {
            // Handle "Sayımı Bitir" action
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => EndInventoryCountingView()),
            );
          },
          child: Text('Sayımı Bitir'),
        ),
      ],
    );
  }
}
