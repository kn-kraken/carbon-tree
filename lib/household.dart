import 'package:carbon_tree/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

class HouseholdRoute extends StatefulWidget {
  @override
  _HouseholdRouteState createState() => _HouseholdRouteState();
}

class _HouseholdRouteState extends State<HouseholdRoute> {
  final _formKey = GlobalKey<FormState>();
  final _waterController = TextEditingController();
  final _gasController = TextEditingController();
  final _trashController = TextEditingController();
  final _electricityController = TextEditingController();

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _waterController.text = localStorage.getItem('water') ?? '';
      _gasController.text = localStorage.getItem('gas') ?? '';
      _trashController.text = localStorage.getItem('trash') ?? '';
      _electricityController.text = localStorage.getItem('electricity') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Household Consumption'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _isChanged = true;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNumericInput(
                    _waterController, 'Water usage', 'cubic meters'),
                SizedBox(height: 16),
                _buildNumericInput(_gasController, 'Gas usage', 'cubic meters'),
                SizedBox(height: 16),
                _buildNumericInput(_trashController, 'Trash disposed', 'kg'),
                SizedBox(height: 16),
                _buildNumericInput(
                    _electricityController, 'Electric power usage', 'kWh'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isChanged ? _onSave : null,
                  child: Text('Save'),
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedIndicators(
                  value: (0.149 * double.parse(_waterController.text) +
                          0.698 * double.parse(_electricityController.text) +
                          0.466 * double.parse(_gasController.text)) /
                      300,
                  getIndicator: ({required scale, required value}) {
                    return ParkIndicator(value, scale: scale * 0.3);
                  },
                ),
                Text(
                    "${((0.149 * double.parse(_waterController.text) + 0.698 * double.parse(_electricityController.text) + 0.466 * double.parse(_gasController.text)) / 307).toStringAsFixed(2)} - number of Skałki Twardowskiego parks needed to recompensate your carbon footprint a day."),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumericInput(
      TextEditingController controller, String label, String unit) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '$label ($unit)',
        suffixText: unit,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      localStorage.setItem('water', _waterController.text);
      localStorage.setItem('gas', _gasController.text);
      localStorage.setItem('trash', _trashController.text);
      localStorage.setItem('electricity', _electricityController.text);

      setState(() {
        _isChanged = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully')),
      );
    }
  }

  @override
  void dispose() {
    _waterController.dispose();
    _gasController.dispose();
    _trashController.dispose();
    _electricityController.dispose();
    super.dispose();
  }
}
