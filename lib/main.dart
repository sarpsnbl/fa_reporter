import 'package:fa_reporter/excel/excel_share.dart';
import 'package:fa_reporter/excel/excel_processor.dart';
import 'package:fa_reporter/utils/app_directory_getset.dart';
import 'package:fa_reporter/utils/excel_getset.dart';
import 'package:fa_reporter/utils/file_load_save.dart';
import 'package:fa_reporter/utils/reports.dart';
import 'package:fa_reporter/widgets/entry_screen/first_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/ocr/text_detector_view.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await preloadAsset('assets/data.xlsx');
  var files = await loadFilesFromDirectory();
  setFiles(files);
  setAppDirectory(await getApplicationDocumentsDirectory());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Demirbaş Sayım Raporlama Sistemi'),
        centerTitle: true,
        elevation: 0,
      ),
      body:
      FirstScreen(),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage,
      {super.key, this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    
    return Card(
      
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (!featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('This feature has not been implemented yet')));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
          }
        },
      ),
    );
  }
}
