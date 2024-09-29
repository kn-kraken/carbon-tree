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
  "Heat: CO\u2082 = Heat × 0.466 kg CO\u2082/kWh",
  "Electricity: CO\u2082 = Electricity × 0.698 kg CO\u2082/kWh",
  "Water: CO\u2082 = Water × 0.149 kg CO\u2082/m\u00b3",
];

class DataSourceAndCO2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Sources and CO2 Emission Metrics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Example CO2 Emission Equations Section
            Text(
              'Example CO\u2082 Emission Equations:',
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
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              height: 350,
                              child: Column(
                                children: [
                                  Text(
                                    'Source 1:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                      'https://www.cire.pl/artykuly/serwis-informacyjny-cire-24/152208-w-finlandii-zmierzono,-ile-co2-pochlania-jedno-drzewo'),
                                  Text(
                                    'Source 2:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                      'https://www.krakow.pl/zalacznik/470573'),
                                  Text(
                                    'Source 3:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                      'https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2024'),
                                  Text(
                                    'Animation 1:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                      'https://rive.app/community/files/798-1554-tree-demo/'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('ok'))
                            ],
                          ),
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
      title: 'Data Sources and CO\u2082 Emission App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataSourceAndCO2(),
    );
  }
}
