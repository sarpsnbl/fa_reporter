// ignore_for_file: prefer_const_constructors

import 'package:fa_reporter/excel/excel_processor.dart';
import 'package:fa_reporter/excel/excel_share.dart';
import 'package:fa_reporter/utils/user_getset.dart';
import 'package:fa_reporter/widgets/entry_screen/first_screen.dart';
import 'package:flutter/material.dart';

class EndInventoryCountingView extends StatefulWidget {
  const EndInventoryCountingView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EndInventoryCountingViewState createState() =>
      _EndInventoryCountingViewState();
}

class _EndInventoryCountingViewState extends State<EndInventoryCountingView> {
  String userTime = getUserCurrentDate();
  @override
  Widget build(BuildContext context) {
    var file = saveReport();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sayım Sona Erdi.'),
      ),
      body: Center(
        child: Column(
          // Use Column to add multiple children
          mainAxisAlignment:
              MainAxisAlignment.center, // Center align the children vertically
          children: [
            Text(
              'Sayım Tamamlandı!', // Example text
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Spacer
            Text("$userTime tarihli sayım tamamlandı."),
            SizedBox(height: 20), // Another spacer
            ExcelShareButton(file: file),
             ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FirstScreen()),
                );
              },
              child: Text('Ana Ekrana Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
