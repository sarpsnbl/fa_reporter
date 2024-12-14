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
            _buildTableRow('Nesne Açıklaması:', data[1]),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Statü:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonFormField<String>(
                    items: ['Sağlam', 'Hurda', 'Arızalı', 'Kayıp'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      data = modifyExcel(2, value, data);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            _buildTableRow('Nesne Grubu Açıklaması:', data[3]),
            _buildTableRow('GY:', data[4]),
            _buildTableRow('GY Açıklama:', data[5]),
            _buildTableRow('IFS Olması Gereken Lokasyon:', data[6]),
            _buildTableRow('Sayım Lokasyonu:', data[7]),
            _buildTableRow('Sayım Doğrulama:', data[8]),
            _buildTableRow('Sayım Tarihi:', data[9]),
            _buildTableRow('Sayım Numarası:', data[10]),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
          child: Text('Nesneyi Kaydet', style: TextStyle(color: Colors.black)),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
    ],
  );
}
