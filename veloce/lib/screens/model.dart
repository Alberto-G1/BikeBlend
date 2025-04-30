import 'package:flutter/material.dart';

class ModelDescriptionScreen extends StatelessWidget {
  const ModelDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/bike_model.png'),
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Model X-100',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Price: UGX 2,000/hr',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Model Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The X-100 is our premium model featuring hydraulic brakes, adjustable suspension, and a lightweight carbon frame. Perfect for both city commuting and light off-road adventures.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Hydraulic brakes\n• Carbon frame\n• Adjustable suspension\n• LED lighting\n• Speedometer',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add your rent bike logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'Rent Now',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}