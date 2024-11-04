import 'package:fa_reporter/excel/excel_example.dart';
import 'package:fa_reporter/utils/time_getter.dart';
import 'package:flutter/material.dart';

class EndInventoryCountingView extends StatefulWidget {
  @override
  _EndInventoryCountingViewState createState() => _EndInventoryCountingViewState();
}

class _EndInventoryCountingViewState extends State<EndInventoryCountingView> {
  String userTime = getUserCurrentDate();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sayım Sona Erdi.'),
      ),
      body: Center(
        child: Column( // Use Column to add multiple children
          mainAxisAlignment: MainAxisAlignment.center, // Center align the children vertically
          children: [
            Text(
              'Sayım Tamamlandı!', // Example text
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Spacer
            Text("${userTime} tarihli sayım tamamlandı."),
            SizedBox(height: 20), // Another spacer
            ExcelShareButton(),
          ],
        ),
      ),
    );
  }
}
