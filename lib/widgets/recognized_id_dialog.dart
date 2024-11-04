import 'package:fa_reporter/widgets/data_entry/data_entry_view.dart';
import 'package:flutter/material.dart';

class DetectedIDDialog extends StatelessWidget {
  final String recognizedID;

  const DetectedIDDialog({required this.recognizedID, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detected ID"),
      content: Text("Detected ID: $recognizedID"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => DataEntryView(recognizedID: recognizedID)),
            );
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
