// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:fa_reporter/main.dart';
import 'package:fa_reporter/utils/user_getset.dart';
import 'package:fa_reporter/widgets/data_entry/previous_data_view.dart';
import 'package:fa_reporter/widgets/ocr/text_detector_view.dart';
import 'package:flutter/material.dart'; // Import the PreviousDataView class

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController inventoryNumberController =
      TextEditingController();
  String? selectedLocation; // Variable to hold the selected dropdown value

 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true, // Allow resizing of the screen
    appBar: AppBar(
      title: Text("KanSay Rapor" // make the text bold and centered
        ,style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
    body: SingleChildScrollView( // Add SingleChildScrollView here
      child: Padding(
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
              onChanged: (value) => setUserName(value),
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
              onChanged: (value) => setTollNumber(value),
            ),
            SizedBox(height: 20), // Spacer
            Text("Sayım Lokasyonunuzu Seçin:"),
            DropdownButton<String>(
              value: selectedLocation,
              hint: Text("Seçin"),
              isExpanded: true,
              items: <String>[
                'ARGE MÜDÜRLÜK',
                'ARGE PERFORMANS',
                'ARGE PME',
                "ARGE POLİMER"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue; // Update selected location
                  setUserLocation(selectedLocation);
                });
              },
            ),
            SizedBox(height: 20), // Spacer
            Text("Tarih: ${getUserCurrentDate()}"),
            ExpansionTile(
              title: const Text('Taramaya Başlayın',),
              children: [
                if (Platform.isAndroid)
                  CustomCard(
                      'Nesne Numarası Tarama', TextRecognizerView()),
              ],
            ),
            const SizedBox(height: 20), // Spacer before the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviousDataView()),
                );
              },
              child: const Text('Önceki Sayımlarım'),
            ),
          ],
        ),
      ),
    ),
  );
  }
}


