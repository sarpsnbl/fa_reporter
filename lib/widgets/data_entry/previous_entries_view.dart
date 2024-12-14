// lib/widgets/data_entry/previous_entries_view.dart
import 'package:flutter/material.dart';

class PreviousEntriesView extends StatelessWidget {
  const PreviousEntriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Önceki Tarananlar'),
      ),
      body: const Center(
        child: Text('Burada önceki tarananlar listelenecek.'),
      ),
    );
  }
}
