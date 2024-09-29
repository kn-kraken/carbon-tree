import 'package:carbon_tree/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _cars = [
  'Toyota Camry',
  'Ford Mustang',
  'Honda Civic',
  'BMW X5',
  'Tesla Model 3',
];

class Journey {
  final String car;
  final double distance;

  Journey(this.car, this.distance);
}

class CarRoute extends StatefulWidget {
  @override
  _CarRouteState createState() => _CarRouteState();
}

class _CarRouteState extends State<CarRoute> {
  final TextEditingController _kmController = TextEditingController();
  final List<String> _items = _cars;
  String _selectedItem = _cars[0];
  List<Journey> _listItems = []; // Empty list to start with
  final _formKey = GlobalKey<FormState>();

  double get totalCO2 {
    return _listItems.fold<double>(0, (prev, journey) => prev + journey.distance * 0.01);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Car Journeys'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Summary(co2: totalCO2,)),
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
                hint: Text('Select an option'),
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
                controller: _kmController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Distance (km)',
                  suffixText: 'km',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a distance';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Submit'),
              ),
              SizedBox(height: 16),
              Divider(thickness: 1),
              Expanded(
                child: _listItems.isEmpty
                    ? Center(child: Text('No data available'))
                    : ListView.builder(
                        itemCount: _listItems.length,
                        itemBuilder: (context, index) {
                          final journey = _listItems[index];
                          return ListTile(
                            title:
                                Text('${journey.car}: ${journey.distance} km'),
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
      var distance = double.tryParse(_kmController.text);
      if (distance != null) {
        setState(() {
          _listItems.add(Journey(_selectedItem, distance));
        });
      }
      _kmController.clear();
    }
  }

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }
}
