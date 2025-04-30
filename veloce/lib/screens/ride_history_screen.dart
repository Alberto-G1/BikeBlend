import 'package:flutter/material.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rides = [
      {
        "from": "Main Street",
        "to": "Park Ave",
        "distance": "2.1 km",
        "fare": "\$2.50",
        "time": "Apr 12, 4:35 PM"
      },
      {
        "from": "Hill View",
        "to": "Market Square",
        "distance": "3.5 km",
        "fare": "\$3.75",
        "time": "Apr 10, 2:10 PM"
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Ride History")),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: rides.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final ride = rides[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("${ride["from"]} ➜ ${ride["to"]}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Distance: ${ride["distance"]}"),
                  Text("Time: ${ride["time"]}"),
                ],
              ),
              trailing: Text(
                ride["fare"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
