import 'package:fa_reporter/widgets/ocr/text_detector_view.dart';
import 'package:fa_reporter/widgets/data_entry/entry_confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:fa_reporter/excel/excel_processor.dart';
import 'package:fa_reporter/utils/user_getset.dart';

// TODO: Debug all this stuff

class DataEntryView extends StatelessWidget {
  final String recognizedID;

  const DataEntryView({super.key, required this.recognizedID});

  @override
  Widget build(BuildContext context) {
    List<String> data = beginExcel(recognizedID);

    if (data.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$recognizedID Numaralı Nesne Bulunamadı!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextRecognizerView(),
                    ),
                  );
                },
                child: Text('Yeniden Tara'),
              ),
            ],
          ),
        ),
      );
    }

    data[9] = getUserCurrentDate();
    data[7] = getUserLocation();
    data[10] = getTollNumber();

    return Scaffold(
      appBar: AppBar(
        title: Text("Demirbaş Girişi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nesne Numarası: $recognizedID'),
            Text('Nesne Açıklaması: ${data[1]}'),
            DropdownButtonFormField<String>(
              items: ['Sağlam', 'Hurda', 'Arızalı', 'Kayıp'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                data = modifyExcel(2, value, data);
              },
              decoration: InputDecoration(labelText: 'Statü: ${data[2]}'),
            ),
            Text('Nesne Grubu Açıklaması: ${data[3]}'),
            Text('GY: ${data[4]}'),
            Text('GY Açıklama: ${data[5]}'),
            Text('IFS Olması Gereken Lokasyon: ${data[6]}'),
            Text('Sayım Lokasyonu: ${data[7]}'),
            Text('Sayım Doğrulama: ${data[8]}'),
            Text('Sayım Tarihi: ${data[9]}'),
            Text('Sayım Numarası: ${data[10]}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var report = getExcelEntries();
                report.add(data);
                showDialog(
                  context: context,
                  builder: (context) => EntryConfirmationPopup(
                    recognizedID: recognizedID,
                  ),
                );
              },
              child: Text('Nesneyi Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}