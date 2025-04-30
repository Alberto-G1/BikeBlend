import 'package:flutter/material.dart';
import 'package:veloce/screens/manage_bikes_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _statCard("Total Rides Today", "124", Icons.directions_bike, theme),
            _statCard("Active Bikes", "58", Icons.lock_open, theme),
            _statCard("Locked Bikes", "42", Icons.lock, theme),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.manage_accounts),
              label: const Text("Manage Bikes"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageBikesScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
