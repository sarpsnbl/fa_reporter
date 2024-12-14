import 'package:fa_reporter/utils/app_directory_getset.dart';
import 'package:fa_reporter/utils/excel_getset.dart';
import 'package:fa_reporter/utils/file_load_save.dart';
import 'package:fa_reporter/widgets/entry_screen/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

var corpYellow = const Color.fromRGBO(252, 217, 1, 1);

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KanSay',
      theme: ThemeData(
        // Use a ColorScheme to control all colors across the app
        colorScheme: ColorScheme(
          primary: corpYellow,        // Primary color
          primaryContainer: Colors.tealAccent,
          secondary: Colors.black,   // Accent color
          secondaryContainer: Colors.black,
          surface: Colors.white,      // Background of cards, dialogs
          error: Colors.red,          // Error messages
          onPrimary: Colors.white,    // Text color on primary
          onSecondary: Colors.black,  // Text color on secondary
          onSurface: Colors.black,    // Text color on surfaces
          onError: Colors.white,      // Text color on errors
          brightness: Brightness.light, // Light or dark mode
        ),

        // Customize specific components globally
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, // Text color
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // Background for input fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: corpYellow,
          foregroundColor: Colors.black, // Title text color
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: corpYellow,
          foregroundColor: Colors.white,
        ),

        checkboxTheme: const CheckboxThemeData(
          fillColor: WidgetStatePropertyAll(Colors.black),
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      resizeToAvoidBottomInset: true,
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
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
