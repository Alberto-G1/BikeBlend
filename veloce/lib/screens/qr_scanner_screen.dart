import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Text("📷 Scanning QR...",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Hero(
              tag: "qr-btn",
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text("Scanning...",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
