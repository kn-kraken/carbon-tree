import 'package:flutter/material.dart';

// Data Source Model
class DataSource {
  final String title;
  final String description;
  final IconData icon;

  DataSource(
      {required this.title, required this.description, required this.icon});
}

// Sample Data Sources
final List<DataSource> dataSources = [
  DataSource(
    title: 'API Data',
    description: 'Data fetched from an external API',
    icon: Icons.api,
  ),
  DataSource(
    title: 'Local Database',
    description: 'Data stored in a local SQLite database',
    icon: Icons.storage,
  ),
  DataSource(
    title: 'File Storage',
    description: 'Data stored in files on the device',
    icon: Icons.folder,
  ),
  DataSource(
    title: 'Cloud Storage',
    description: 'Data stored in cloud services',
    icon: Icons.cloud,
  ),
];

// Example CO2 Emission Equations
List<String> exampleEquations = [
  "Gasoline: CO2 = Gallons × 8.89 kg CO2/gallon",
  "Diesel: CO2 = Gallons × 10.16 kg CO2/gallon",
  "Example: 10 Gallons of Gasoline = 10 × 8.89 = 88.9 kg CO2",
  "Example: 5 Gallons of Diesel = 5 × 10.16 = 50.8 kg CO2",
];

class DataSourceAndCO2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Sources and CO2 Emission Equations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Example CO2 Emission Equations Section
            Text(
              'Example CO2 Emission Equations:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: exampleEquations.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        exampleEquations[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Data Source List Section
            Text(
              'Data Sources:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataSources.length,
                itemBuilder: (context, index) {
                  final dataSource = dataSources[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(dataSource.icon, size: 40),
                      title: Text(dataSource.title,
                          style: TextStyle(fontSize: 18)),
                      subtitle: Text(dataSource.description),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Selected: ${dataSource.title}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Application
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Sources and CO2 Emission App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataSourceAndCO2(),
    );
  }
}
