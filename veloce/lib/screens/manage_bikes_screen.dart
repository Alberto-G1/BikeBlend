import 'package:flutter/material.dart';

class ManageBikesScreen extends StatelessWidget {
  const ManageBikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bikes = List.generate(10, (i) => "Bike #${100 + i}");
    final lockStates = List.generate(10, (i) => i % 2 == 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Bikes")),
      body: ListView.separated(
        itemCount: bikes.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bikes[index]),
            trailing: Switch(
              value: lockStates[index],
              onChanged: (val) {
                // Simulate lock/unlock toggle
              },
            ),
            subtitle: Text(lockStates[index] ? "Unlocked" : "Locked"),
          );
        },
      ),
    );
  }
}
