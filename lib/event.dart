import 'package:flutter/material.dart';
import 'summary.dart';

class EventsList extends StatelessWidget {
  final List<Event> events = [
    Event(
      name: 'Konferencja dotycząca tworzenia społeczności energetycznej',
      co2Emission: 1000,
      treeIndicator: 1000 / 7,
    ),
    Event(name: 'Cracow Film Festival', co2Emission: 6, treeIndicator: 6 / 7),
    Event(name: 'Cracow Book Fair', co2Emission: 0.8, treeIndicator: 0.8 / 7),
    Event(
        name: 'Cracow Easter Festival',
        co2Emission: 3.5,
        treeIndicator: 3.5 / 7),
  ];

  EventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cracow City Events'),
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

class Event {
  final String name;
  final double co2Emission;
  final double treeIndicator;

  Event(
      {required this.name,
      required this.co2Emission,
      required this.treeIndicator});
}
