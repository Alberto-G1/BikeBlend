import 'package:flutter/material.dart';
import 'dart:async';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with SingleTickerProviderStateMixin {
  bool _isFlashlightOn = false;
  bool _isScanning = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // Setup animation for the scanning line
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    
    // Simulate QR code detection after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;
    
    return Scaffold(
      body: Stack(
        children: [
          // Camera background
          Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
          ),
          
          // Scan overlay with transparent center
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          
          // Scanning line animation
          if (_isScanning)
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    top: (size.height - scanAreaSize) / 2 + scanAreaSize * _animation.value,
                    left: (size.width - scanAreaSize) / 2,
                    child: Container(
                      width: scanAreaSize,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0),
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Corner markers for scan area
          Center(
            child: SizedBox(
              width: scanAreaSize,
              height: scanAreaSize,
              child: Stack(
                children: [
                  // Top left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(theme),
                  ),
                  // Top right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: _buildCorner(theme),
                    ),
                  ),
                  // Bottom right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: 180 * 3.14159 / 180,
                      child: _buildCorner(theme),
                    ),
                  ),
                  // Bottom left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Transform.rotate(
                      angle: 270 * 3.14159 / 180,
                      child: _buildCorner(theme),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Status text
          Positioned(
            top: (size.height - scanAreaSize) / 2 - 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _isScanning ? "Position QR code within frame" : "QR Code Detected!",
                style: TextStyle(
                  color: _isScanning ? Colors.white : theme.colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          
          // Flashlight toggle
          Positioned(
            top: 40,
            right: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: Icon(
                    _isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFlashlightOn = !_isFlashlightOn;
                    });
                    // Here you would actually toggle the device flashlight
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFlashlightOn ? "Flashlight turned on" : "Flashlight turned off"
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Bottom action button
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Hero(
              tag: "qr-btn",
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (!_isScanning) {
                      // Show success dialog when QR is detected
                      _showSuccessDialog(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: _isScanning 
                          ? theme.colorScheme.primary.withOpacity(0.8)
                          : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isScanning)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          if (_isScanning)
                            const SizedBox(width: 12),
                          Text(
                            _isScanning ? "Scanning..." : "Unlock Bike",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Gallery button to select QR from photos
          Positioned(
            bottom: 140,
            right: 20,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(Icons.photo_library, color: Colors.white, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Opening gallery to select QR code"),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCorner(ThemeData theme) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.primary, width: 3),
          left: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
      ),
    );
  }
  
  void _showSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text("Success!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Bike unlocked successfully. Enjoy your ride!",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Bike ID:"),
                      Text("VL-2023-MTB", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Start Time:"),
                      Text("10:30 AM", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Start Ride"),
          ),
        ],
      ),
    );
  }
}
