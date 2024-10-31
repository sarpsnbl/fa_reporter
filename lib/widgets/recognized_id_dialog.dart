import 'package:flutter/material.dart';

class DetectedIDDialog extends StatelessWidget {
  final String recognizedID;

  const DetectedIDDialog({required this.recognizedID, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detected ID"),
      content: Text("Detected ID: $recognizedID"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
        ),
      ],
    );
  }

  String getRecognizedID() {
    return recognizedID;
  }
}
