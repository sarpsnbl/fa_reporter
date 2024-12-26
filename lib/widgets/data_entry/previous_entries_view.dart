import 'package:fa_reporter/utils/user_getset.dart';
import 'package:flutter/material.dart';

class PreviousEntriesView extends StatefulWidget {
  const PreviousEntriesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PreviousEntriesViewState createState() => _PreviousEntriesViewState();
}

class _PreviousEntriesViewState extends State<PreviousEntriesView> {
  late List<List<String>> editableEntries;
  int? selectedEntryIndex;

  final List<String> columnTitles = [
    "Nesne Numarası",
    "Nesne Açıklaması",
    "Statü",
    "Nesne Grubu Açıklaması",
    "GY",
    "GY Açıklama",
    "IFS Olması Gereken Lokasyon",
    "Sayım Lokasyonu",
    "Sayım Doğrulama",
    "Sayım Tarihi",
    "Sayım No",
  ];

  final List<String> statusOptions = ["Sağlam", "Hurda", "Arızalı", "Kayıp"];

  @override
  void initState() {
    super.initState();
    editableEntries = getExcelEntries();
  }

  void updateEntry(int rowIndex, int colIndex, String value) {
    setState(() {
      editableEntries[rowIndex][colIndex] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Önceki Tarananlar'),
      ),
      body: selectedEntryIndex == null
          ? editableEntries.isEmpty
              ? const Center(child: Text('No entries available.'))
              : ListView.builder(
                  itemCount: editableEntries.length,
                  itemBuilder: (context, rowIndex) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(editableEntries[rowIndex][0]),
                        onTap: () {
                          setState(() {
                            selectedEntryIndex = rowIndex;
                          });
                        },
                      ),
                    );
                  },
                )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            editableEntries[selectedEntryIndex!][0],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(
                              editableEntries[selectedEntryIndex!].length,
                              (colIndex) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: colIndex == 2
                                  ? DropdownButtonFormField<String>(
                                      value:
                                          editableEntries[selectedEntryIndex!]
                                              [colIndex],
                                      items: statusOptions
                                          .map((status) =>
                                              DropdownMenuItem<String>(
                                                value: status,
                                                child: Text(status),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          updateEntry(selectedEntryIndex!,
                                              colIndex, value);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: columnTitles[colIndex],
                                        border: const OutlineInputBorder(),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          columnTitles[colIndex],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            editableEntries[selectedEntryIndex!]
                                                [colIndex],
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          }),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedEntryIndex = null;
                              });
                            },
                            child: const Text('Tarananlara Geri Dön'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
