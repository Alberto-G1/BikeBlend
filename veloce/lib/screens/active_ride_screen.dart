import 'package:flutter/material.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  Duration _rideDuration = Duration.zero;
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _rideDuration = _stopwatch.elapsed;
        });
      }
      return true;
    });
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride in Progress"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: const Center(
                child: Icon(Icons.map_rounded, size: 80, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Ride Duration",
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Text(
                    _formatDuration(_rideDuration),
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _rideStat(theme, "Distance", "1.3 KM", Icons.alt_route),
                      _rideStat(theme, "Speed", "18 KM/h", Icons.speed),
                      _rideStat(theme, "Calories", "102 cal", Icons.local_fire_department),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Pause logic placeholder
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.secondary.withOpacity(0.2),
                            foregroundColor: theme.colorScheme.secondary,
                          ),
                          child: const Text("Pause"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: const Text("End Ride"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rideStat(ThemeData theme, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(value,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
