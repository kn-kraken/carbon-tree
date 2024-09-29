import 'package:flutter/material.dart';
import 'summary.dart';

class ServicesList extends StatelessWidget {
  final List<Service> events = [
    Service(
      name: 'Hotel night in Poland',
      co2Emission: 27,
      treeIndicator: 27 / 7,
    ),
  ];

  ServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cracow Services'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(events[index].name),
              subtitle: Text(
                  'Estimated CO\u2082 Emission: ${events[index].co2Emission} kg - ${events[index].treeIndicator.toStringAsFixed(2)} large trees would need 1 day to absorb it.'),
              trailing: TreeIndicator(events[index].treeIndicator, scale: 0.5),
            ),
          );
        },
      ),
    );
  }
}

class Service {
  final String name;
  final double co2Emission;
  final double treeIndicator;

  Service(
      {required this.name,
      required this.co2Emission,
      required this.treeIndicator});
}
