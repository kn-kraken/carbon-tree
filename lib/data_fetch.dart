import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:excel/excel.dart';

class ExcelFetchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gov Excel Data Fetch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Excel Data Table Widget
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExcelDataTable(),
                  ),
                );
              },
              child: Text('Fetch Excel Data'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExcelDataTable extends StatefulWidget {
  @override
  _ExcelDataTableState createState() => _ExcelDataTableState();
}

class _ExcelDataTableState extends State<ExcelDataTable> {
  List<List<dynamic>> _data = [];
  bool _loading = false;
  bool _error = false;

  Future<void> _fetchExcel() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    // Replace this URL with the actual government Excel file URL
    final url =
        'https://api.dane.gov.pl/media/resources/20240328/Wykaz_SCHE.xlsx';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        // Parse the Excel file
        var excel = Excel.decodeBytes(bytes);

        // Convert Excel sheet data to List<List<dynamic>> for displaying in DataTable
        List<List<dynamic>> sheetData = [];
        for (var table in excel.tables.keys) {
          var rows = excel.tables[table]?.rows;
          if (rows != null) {
            sheetData = rows;
            break; // Assuming we want the first sheet, you can adjust this logic if needed
          }
        }

        setState(() {
          _data = sheetData;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExcel(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Data Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : _error
                ? Center(child: Text('Error fetching data'))
                : _data.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _data[0]
                              .map((header) => DataColumn(
                                    label: Text(header.toString()),
                                  ))
                              .toList(),
                          rows: _data
                              .skip(1) // Skip header row
                              .map(
                                (row) => DataRow(
                                  cells: row
                                      .map((cell) => DataCell(
                                            Text(cell.toString()),
                                          ))
                                      .toList(),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : Center(child: Text('No data loaded')),
      ),
    );
  }
}
