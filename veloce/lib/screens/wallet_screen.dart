import 'package:flutter/material.dart';
import 'payment_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactions = [
      {"title": "Ride - VX1289", "amount": "-\$2.50", "time": "Today, 10:30 AM"},
      {"title": "Top-Up", "amount": "+\$10.00", "time": "Yesterday, 5:00 PM"},
      {"title": "Ride - VX1172", "amount": "-\$3.00", "time": "2 days ago"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Balance",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    "\$12.75",
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const PaymentScreen(),
                          transitionsBuilder: (_, anim, __, child) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("Top Up"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Transactions",
                  style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 10),
            ...transactions.map((txn) => ListTile(
                  leading: Icon(
                    txn["amount"].toString().startsWith("-")
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: txn["amount"].toString().startsWith("-")
                        ? Colors.red
                        : Colors.green,
                  ),
                  title: Text(txn["title"]!),
                  subtitle: Text(txn["time"]!),
                  trailing: Text(txn["amount"]!,
                      style: TextStyle(
                        color: txn["amount"].toString().startsWith("-")
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
