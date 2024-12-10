// lib/widgets/data_entry/previous_entries_view.dart
import 'package:flutter/material.dart';

class PreviousEntriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Önceki Tarananlar'),
      ),
      body: Center(
        child: Text('Burada önceki tarananlar listelenecek.'),
      ),
    );
  }
}
