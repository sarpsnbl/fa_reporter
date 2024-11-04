import 'package:flutter/material.dart';

class PreviousDataView extends StatefulWidget {
  @override
  _PreviousDataViewState createState() => _PreviousDataViewState();
}

class _PreviousDataViewState extends State<PreviousDataView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Önceki Girişler"),
      )
    );
  }
}
