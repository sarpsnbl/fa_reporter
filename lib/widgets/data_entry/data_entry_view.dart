import 'package:fa_reporter/widgets/ocr/text_detector_view.dart';
import 'package:fa_reporter/widgets/data_entry/entry_confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:fa_reporter/excel/excel_processor.dart';
import 'package:fa_reporter/utils/user_getset.dart';

const Map columns = {
  "Nesne": 0,
  "Nesne Açıklaması": 1,
  "Statü:": 2,
  "Nesne Grubu Açıklaması": 3,
  "GY": 4,
  "GY Açıklama": 5,
  "IFS Olması Gereken Lokasyon": 6,
  "Sayım Lokasyonu": 7,
  "Sayım Doğrulama": 8,
  "Sayım Tarihi": 9,
  "Sayım Numarası": 10
};

class DataEntryView extends StatelessWidget {
  final String recognizedID;

  const DataEntryView({super.key, required this.recognizedID});

  @override
  Widget build(BuildContext context) {
    List<String> data = [];
    List<List<String>> rows = beginExcel(recognizedID);
    if (rows.length == 1) {
      data = rows[0];
    } else {
      //TODO:
      // send user to item selection screen and then assign data from its return
    }

    if (data.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$recognizedID Numaralı Nesne Bulunamadı!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TextRecognizerView(),
                    ),
                  );
                },
                child: const Text('Yeniden Tara'),
              ),
            ],
          ),
        ),
      );
    }

    data[columns['Sayım Tarihi']] = getUserCurrentDate();
    data[columns['Sayım Lokasyonu']] = getUserLocation();
    data[columns['Sayım Numarası']] = getTollNumber();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demirbaş Girişi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Table(
              border: TableBorder.all(
                color: Colors.grey,
                width: 1.0,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow('Nesne Numarası:', recognizedID),
                _buildTableRow(
                    'Nesne Açıklaması:', data[columns['Nesne Açıklaması']]),
                _buildTableRow('Nesne Grubu Açıklaması:',
                    data[columns['Nesne Grubu Açıklaması']]),
                _buildTableRow('GY:', data[columns['GY']]),
                _buildTableRow('GY Açıklama:', data[columns['GY Açıklama']]),
                _buildTableRow('IFS Olması Gereken Lokasyon:',
                    data[columns['IFS Olması Gereken Lokasyon']]),
                _buildTableRow(
                    'Sayım Lokasyonu:', data[columns['Sayım Lokasyonu']]),
                _buildTableRow(
                    'Sayım Doğrulama:', data[columns['Sayım Doğrulama']]),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Statü:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButtonFormField<String>(
                        items: ['Sağlam', 'Hurda', 'Arızalı', 'Kayıp']
                            .map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          data = modifyExcel(columns['Statü'], value, data);
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildTableRow('Sayım Tarihi:', data[columns['Sayım Tarihi']]),
                _buildTableRow(
                  'Sayım Numarası:',
                  data[columns['Sayım Numarası']],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
              ),
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
              child: const Text('Nesneyi Kaydet',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

TableRow _buildTableRow(String label, String value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
    ],
  );
}
