import 'package:carbon_tree/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Food Consumption'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Summary(
                            co2: _listItems.length * 0.01,
                          )),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
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

  void _uploadReceipt() {
    // Implement receipt upload functionality here
    print('Upload receipt functionality to be implemented');
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }
}
