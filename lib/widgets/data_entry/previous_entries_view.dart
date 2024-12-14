import 'package:fa_reporter/utils/user_getset.dart';
import 'package:flutter/material.dart';

// Assuming this function directly returns the List<List<String>>
// Replace with the actual implementation of getExcelEntries() if needed


class PreviousEntriesView extends StatefulWidget {
  const PreviousEntriesView({super.key});

  @override
  _PreviousEntriesViewState createState() => _PreviousEntriesViewState();
}

class _PreviousEntriesViewState extends State<PreviousEntriesView> {
  late List<List<String>> editableEntries;
  int? selectedEntryIndex;

  @override
  void initState() {
    super.initState();
    // Directly initialize the entries synchronously
    editableEntries = getExcelEntries();
  }

  // Function to update the data when a cell is edited
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
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(editableEntries[rowIndex][0]), // Show the first element of the entry
                        onTap: () {
                          setState(() {
                            selectedEntryIndex = rowIndex; // Set the selected entry index
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
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Editing: ${editableEntries[selectedEntryIndex!][0]}', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          ...List.generate(editableEntries[selectedEntryIndex!].length, (colIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextField(
                                controller: TextEditingController(text: editableEntries[selectedEntryIndex!][colIndex]),
                                decoration: InputDecoration(
                                  labelText: 'Column ${colIndex + 1}', // Dynamic label for columns
                                ),
                                onChanged: (value) {
                                  updateEntry(selectedEntryIndex!, colIndex, value);
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedEntryIndex = null; // Deselect the entry after editing
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
