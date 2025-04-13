import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bike_bliss/theme/app_theme.dart';
import 'package:bike_bliss/models/bike.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _animationController;
  bool _isFilterVisible = false;
  String _selectedBikeType = 'All';
  
  // Sample bike data
  final List<Bike> _bikes = [
    Bike(
      id: '1',
      name: 'City Cruiser',
      type: 'Electric',
      distance: 0.3,
      batteryLevel: 85,
      pricePerMinute: 0.25,
      imageUrl: 'https://images.unsplash.com/photo-1558981285-6f0c94958bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZWxlY3RyaWMlMjBiaWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
      location: 'Central Park',
    ),
    Bike(
      id: '2',
      name: 'Mountain Explorer',
      type: 'Standard',
      distance: 0.5,
      batteryLevel: null,
      pricePerMinute: 0.15,
      imageUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmljeWNsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
      location: 'Riverside',
    ),
    Bike(
      id: '3',
      name: 'Urban Speedster',
      type: 'Electric',
      distance: 0.8,
      batteryLevel: 92,
      pricePerMinute: 0.30,
      imageUrl: 'https://images.unsplash.com/photo-1571068316344-75bc76f77890?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZWxlY3RyaWMlMjBiaWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
      location: 'Downtown',
    ),
    Bike(
      id: '4',
      name: 'Commuter Pro',
      type: 'Standard',
      distance: 1.2,
      batteryLevel: null,
      pricePerMinute: 0.18,
      imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmlrZXxlbnwwfHwwfHw%3D&w=1000&q=80',
      location: 'City Square',
    ),
    Bike(
      id: '5',
      name: 'Eco Rider',
      type: 'Electric',
      distance: 1.5,
      batteryLevel: 65,
      pricePerMinute: 0.28,
      imageUrl: 'https://images.unsplash.com/photo-1558981285-6f0c94958bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZWxlY3RyaWMlMjBiaWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
      location: 'Green Park',
    ),
  ];
  
  // New York City coordinates
  final LatLng _center = const LatLng(40.7128, -74.0060);
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggleFilter() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
    
    if (_isFilterVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  
  List<Bike> get _filteredBikes {
    if (_selectedBikeType == 'All') {
      return _bikes;
    } else {
      return _bikes.where((bike) => bike.type == _selectedBikeType).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              // center: _center,
              // zoom: 14.0,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: isDarkMode
                    ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
                    : 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.example.bike_bliss',
              ),
              MarkerLayer(
                markers: _filteredBikes.map((bike) {
                  // Generate random positions around NYC for demo
                  final random = DateTime.now().millisecondsSinceEpoch % 1000 / 10000;
                  final lat = _center.latitude + (bike.id.hashCode % 10) * 0.01 - 0.05 + random;
                  final lng = _center.longitude + (bike.id.hashCode % 7) * 0.01 - 0.03 + random;
                  
                  return Marker(
                    width: 60.0,
                    height: 60.0,
                    point: LatLng(lat, lng),
                    child: GestureDetector(
                      onTap: () {
                        _showBikeDetails(bike);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: bike.type == 'Electric'
                                  ? AppTheme.primaryColor
                                  : Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              bike.type == 'Electric'
                                  ? Icons.electric_bike
                                  : Icons.pedal_bike,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          
          // App bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        // Go back to home screen
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search for locations",
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.primaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Filter button
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFilterVisible ? Icons.close : Icons.filter_list,
                      color: _isFilterVisible ? AppTheme.primaryColor : null,
                    ),
                    onPressed: _toggleFilter,
                  ),
                ),
                
                // Filter options
                SizeTransition(
                  sizeFactor: _animationController,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bike Type",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildFilterOption('All'),
                        _buildFilterOption('Electric'),
                        _buildFilterOption('Standard'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Current location button
          Positioned(
            bottom: 100,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.my_location,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  // Center map on user's location
                  _mapController.move(_center, 15.0);
                },
              ),
            ),
          ),
          
          // Bottom info
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bikes Nearby",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Found ${_filteredBikes.length} bikes in your area",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterOption(String type) {
    final isSelected = _selectedBikeType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBikeType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  void _showBikeDetails(Bike bike) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    bike.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bike.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              bike.type,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bike.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${bike.distance} km away",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.attach_money,
                  title: "Price",
                  value: "\$${bike.pricePerMinute.toStringAsFixed(2)}/min",
                ),
                _buildInfoItem(
                  context,
                  icon: bike.batteryLevel != null ? Icons.battery_charging_full : Icons.pedal_bike,
                  title: "Type",
                  value: bike.batteryLevel != null ? "${bike.batteryLevel}% Battery" : "Standard",
                  valueColor: bike.batteryLevel != null ? _getBatteryColor(bike.batteryLevel!) : null,
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.star,
                  title: "Rating",
                  value: "4.8/5",
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to scan screen or show QR scanner
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Unlock Bike",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
  
  Color _getBatteryColor(int level) {
    if (level > 70) {
      return Colors.green;
    } else if (level > 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
