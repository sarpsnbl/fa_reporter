import 'package:fa_reporter/widgets/data_entry/entry_confirmation_popup.dart';
import 'package:flutter/material.dart';

class DataEntryView extends StatelessWidget {
  final String recognizedID;

  const DataEntryView({super.key, required this.recognizedID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demirbaş Girişi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Nesne Numarası: $recognizedID',
            ),
            Text(
              'Nesne Açıklaması:',
            ),
            DropdownButtonFormField<String>(
              items: ['Sağlam', 'Hurda', 'Arızalı', 'Kayıp'].map((statu) {
                return DropdownMenuItem(
                  value: statu,
                  child: Text(statu),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(labelText: 'Statü'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Nesne Grubu Açıklaması'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'GY'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'GY Açıklama'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Sayım Lokasyonu'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Sayım Doğrıulama'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Sayım Tarihi'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Sayım Numarası'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
                showDialog(
                  context: context,
                  builder: (context) => EntryConfirmationPopup(recognizedID: recognizedID),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
