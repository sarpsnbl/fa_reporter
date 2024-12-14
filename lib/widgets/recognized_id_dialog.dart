import 'package:fa_reporter/widgets/data_entry/data_entry_view.dart';
import 'package:flutter/material.dart';

class DetectedIDDialog extends StatefulWidget {
  final String recognizedID;

  const DetectedIDDialog({required this.recognizedID, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetectedIDDialogState createState() => _DetectedIDDialogState();
}

class _DetectedIDDialogState extends State<DetectedIDDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.recognizedID); // Initialize with the recognized ID
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Bulunan Nesne"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Bulunan Nesne Numarası:"),
          const SizedBox(height: 16),
          TextField(
            controller: _controller, // Allow editing of the ID
            decoration: const InputDecoration(
              labelText: "Nesne Numarasını Düzenle",
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => DataEntryView(recognizedID: _controller.text)),
            );
          },
          child: const Text("OK"),
        )
      ],
    );
  }
}
