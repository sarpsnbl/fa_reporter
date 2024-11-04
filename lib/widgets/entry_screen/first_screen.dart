import 'package:fa_reporter/utils/time_getter.dart';
import 'package:fa_reporter/widgets/data_entry/previous_data_view.dart';
import 'package:flutter/material.dart';// Import the PreviousDataView class

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController inventoryNumberController = TextEditingController();
  String? selectedLocation; // Variable to hold the selected dropdown value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demirbaş Rapor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hoş Geldiniz.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Spacer
            Text("İsminiz:"),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "İsminizi girin",
              ),
            ),
            SizedBox(height: 20), // Spacer
            Text("Sayım No:"),
            TextField(
              controller: inventoryNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Sayım numarasını girin",
              ),
              keyboardType: TextInputType.number, // Numeric keyboard for numbers
            ),
            SizedBox(height: 20), // Spacer
            Text("Sayım Lokasyonunuzu Seçin:"),
            DropdownButton<String>(
              value: selectedLocation,
              hint: Text("Seçin"),
              isExpanded: true,
              items: <String>['foo', 'bar', 'faz'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue; // Update selected location
                });
              },
            ),
            SizedBox(height: 20), // Spacer
            Text("Tarih: ${getUserCurrentDate()}"),
            const Spacer(), // Spacer to push the button to the bottom
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreviousDataView()),
                );
              },
              child: const Text('Önceki Sayımlarım'),
            ),
          ],
        ),
      ),
    );
  }
}
