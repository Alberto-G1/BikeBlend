import 'package:flutter/material.dart';

class UnlockSimulationScreen extends StatefulWidget {
  const UnlockSimulationScreen({super.key});

  @override
  State<UnlockSimulationScreen> createState() => _UnlockSimulationScreenState();
}

class _UnlockSimulationScreenState extends State<UnlockSimulationScreen> {
  bool isUnlocking = false;
  bool isUnlocked = false;

  void _simulateUnlock() async {
    setState(() {
      isUnlocking = true;
      isUnlocked = false;
    });

    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isUnlocking = false;
      isUnlocked = true;
    });

    // Optionally simulate haptic/vibration
    // HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Unlock Simulation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUnlocking)
              const CircularProgressIndicator()
            else if (isUnlocked)
              Column(
                children: [
                  const Icon(Icons.lock_open, size: 60, color: Colors.green),
                  const SizedBox(height: 10),
                  Text("Bike Unlocked!", style: theme.textTheme.headlineSmall),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: _simulateUnlock,
                icon: const Icon(Icons.lock),
                label: const Text("Simulate Unlock"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
