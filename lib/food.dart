import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

const _foodItems = [
  'Beef',
  'Chicken',
  'Pork',
  'Fish',
  'Vegetables',
];

class FoodRoute extends StatefulWidget {
  @override
  _FoodRouteState createState() => _FoodRouteState();
}

class _FoodRouteState extends State<FoodRoute> {
  final TextEditingController _gramsController = TextEditingController();
  final List<String> _items = _foodItems;
  String _selectedItem = _foodItems[0];
  List<String> _listItems = []; // Empty list to start with
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Food Consumption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedItem,
                hint: Text('Select a food item'),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                  }
                },
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _gramsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount (grams)',
                  suffixText: 'g',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Submit'),
              ),
              SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _uploadReceipt,
                icon: Icon(Icons.upload_file),
                label: Text('Upload Receipt'),
              ),
              SizedBox(height: 16),
              Divider(thickness: 1),
              Expanded(
                child: _listItems.isEmpty
                    ? Center(child: Text('No data available'))
                    : ListView.builder(
                        itemCount: _listItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_listItems[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      print('Selected item: $_selectedItem');
      print('Amount: ${_gramsController.text} g');

      // Here you can add the logic to update your list
      setState(() {
        _listItems.add('${_selectedItem}: ${_gramsController.text} g');
      });
      // Clear the form
      _gramsController.clear();
    }
  }

  Future<void> _uploadReceipt() async {
    await _selectPdfAndExtractText();
  }

  Future<void> _selectPdfAndExtractText() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdfFile = File(result.files.single.path!);
      await _extractTextFromPdf(pdfFile);
    } else {
      print("No PDF selected.");
    }
  }

  Future<void> _extractTextFromPdf(File pdfFile) async {
    try {
      List<File> imageFiles = await _convertPdfToImages(pdfFile);
      List<String> allDetectedWords = []; // Store words in a list

      // Detect text from each image
      for (var imageFile in imageFiles) {
        String detectedText = await _detectTextFromImage(imageFile);
        String filteredText = _filterWords(detectedText);

        // Add filtered words only if they're non-empty
        if (filteredText.isNotEmpty) {
          allDetectedWords.addAll(filteredText.split(' '));
        }
      }

      // Update the recognized words for UI
      setState(() {
        _listItems = allDetectedWords;
      });

      // Print the final list of recognized words
    } catch (e) {
      //professional error handling
    }
  }

  String _filterWords(String text) {
    // List of common food-related words in Polish
    final List<String> foodRelatedWords = [
      'jabłko',
      'banan',
      'gruszka',
      'chleb',
      'bułka',
      'ser',
      'mięso',
      'ryba',
      'masło',
      'mleko',
      'jajko',
      'pomidor',
      'ogórek',
      'marchew',
      'ziemniak',
      'sałata',
      'czekolada',
      'kawa',
      'herbata',
      'cukier',
      'sól',
      'pieprz',
      'makaron',
      'ryż',
      'ciasto',
      'bagietka',
      'papryka',
      'cebula',
      'boczek',
      'tost'
    ];

    // Convert food-related words to lowercase for case-insensitive comparison
    final Set<String> foodRelatedWordsSet =
        foodRelatedWords.map((word) => word.toLowerCase()).toSet();

    // Split recognized text into words
    List<String> allWords =
        text.split(RegExp(r'\s+')); // Split by spaces or newlines

    // Print recognized text and words (for debugging)
    print("Recognized Words: $allWords");

    // Filter out words that are not in the food-related words list (case-insensitive)
    List<String> filteredWords = allWords.where((word) {
      return foodRelatedWordsSet
          .contains(word.toLowerCase()); // Case-insensitive comparison
    }).toList();

    // Print filtered words (for debugging)
    print("Filtered Words: $filteredWords");

    // Return the filtered words as a space-separated string
    return filteredWords.join(' ');
  }

  Future<List<File>> _convertPdfToImages(File pdfFile) async {
    final List<File> imageFiles = [];
    final tempDir = await getTemporaryDirectory();

    // Initialize PDF document
    final document = await PdfDocument.openFile(pdfFile.path);

    for (int pageNumber = 1; pageNumber <= document.pagesCount; pageNumber++) {
      final page = await document.getPage(pageNumber);
      final pageImage = await page.render(
        width: page.width * 2, // Render with higher resolution
        height: page.height * 2,
        format: PdfPageImageFormat.png, // Render as PNG
      );

      final imgFile = File('${tempDir.path}/page_$pageNumber.png');
      await imgFile.writeAsBytes(pageImage!.bytes);
      imageFiles.add(imgFile);

      await page.close();
    }

    await document.close();
    return imageFiles;
  }

  Future<String> _detectTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textDetector = GoogleMlKit.vision.textRecognizer();

    final RecognizedText recognizedText =
        await textDetector.processImage(inputImage);
    String detectedText = recognizedText.text;

    print("Detected Text: $detectedText"); // Debugging step

    textDetector.close(); // Remember to close the detector

    return detectedText;
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }
}
