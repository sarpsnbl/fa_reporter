import 'dart:io';

import 'package:fa_reporter/main.dart';
import 'package:fa_reporter/utils/user_getset.dart';
import 'package:fa_reporter/widgets/data_entry/previous_data_view.dart';
import 'package:fa_reporter/widgets/ocr/text_detector_view.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController inventoryNumberController =
      TextEditingController();
  String? selectedLocation;

  
  bool isNameEmpty = false;
  bool isInventoryEmpty = false;
  bool isLocationEmpty = false;

  void validateForm() {
    setState(() {
      isNameEmpty = nameController.text.isEmpty;
      isInventoryEmpty = inventoryNumberController.text.isEmpty;
      isLocationEmpty = selectedLocation == null;
    });

    
    if (isNameEmpty || isInventoryEmpty || isLocationEmpty) {
      return;
    }

    // Tüm alanlar doluysa, devam et
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextRecognizerView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "KanSay Rapor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hoş Geldiniz.",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("İsminiz:"),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "İsminizi girin",
                  errorText: isNameEmpty ? "Lütfen isminizi giriniz!" : null,
                ),
                onChanged: (value) {
                  setState(() {
                    isNameEmpty = value.isEmpty;
                  });
                  setUserName(value);
                },
              ),
              SizedBox(height: 20),
              Text("Sayım No:"),
              TextField(
                controller: inventoryNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Sayım numarasını girin",
                  errorText: isInventoryEmpty
                      ? "Lütfen sayım numarasını giriniz!"
                      : null,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    isInventoryEmpty = value.isEmpty;
                  });
                  setTollNumber(value);
                },
              ),
              SizedBox(height: 20),
              Text("Sayım Lokasyonunuzu Seçin:"),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText:
                      isLocationEmpty ? "Lütfen bir lokasyon seçiniz!" : null,
                ),
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
                    selectedLocation = newValue;
                    isLocationEmpty = newValue == null;
                  });
                  setUserLocation(selectedLocation);
                },
              ),
              SizedBox(height: 20),
              Text("Tarih: ${getUserCurrentDate()}"),
              ExpansionTile(
                title: const Text(
                  'Taramaya Başlayın',
                ),
                children: [
                  ElevatedButton(
                    onPressed: validateForm,
                    child: const Text("Kamera ile Tarama"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      inventoryNumberController.text.isEmpty ||
                      selectedLocation == null) {
                    validateForm();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreviousDataView(),
                      ),
                    );
                  }
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
