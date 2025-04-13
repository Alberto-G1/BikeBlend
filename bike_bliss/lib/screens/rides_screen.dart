import 'package:flutter/material.dart';
import 'package:bike_bliss/theme/app_theme.dart';
import 'package:bike_bliss/models/ride.dart';
import 'package:intl/intl.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample ride data
  final List<Ride> _pastRides = [
    Ride(
      id: '1',
      bikeName: 'City Cruiser',
      bikeType: 'Electric',
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      distance: 5.7,
      cost: 8.50,
      startLocation: 'Central Park',
      endLocation: 'Times Square',
      imageUrl: 'https://images.unsplash.com/photo-1558981285-6f0c94958bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZWxlY3RyaWMlMjBiaWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
    ),
    Ride(
      id: '2',
      bikeName: 'Mountain Explorer',
      bikeType: 'Standard',
      startTime: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 5)),
      distance: 3.2,
      cost: 4.80,
      startLocation: 'Riverside',
      endLocation: 'Downtown',
      imageUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmljeWNsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
    ),
    Ride(
      id: '3',
      bikeName: 'Urban Speedster',
      bikeType: 'Electric',
      startTime: DateTime.now().subtract(const Duration(days: 7, hours: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 7, hours: 1, minutes: 15)),
      distance: 8.5,
      cost: 12.75,
      startLocation: 'Brooklyn Bridge',
      endLocation: 'Central Station',
      imageUrl: 'https://images.unsplash.com/photo-1571068316344-75bc76f77890?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZWxlY3RyaWMlMjBiaWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
    ),
  ];
  
  final List<Ride> _upcomingRides = [
    Ride(
      id: '4',
      bikeName: 'City Explorer',
      bikeType: 'Electric',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      endTime: null,
      distance: null,
      cost: null,
      startLocation: 'Central Park',
      endLocation: null,
      imageUrl: 'https://images.unsplash.com/photo-1558981285-6f0c94958bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZWxlY3RyaWMlMjBiaWtlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Rides",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Past Rides"),
            Tab(text: "Upcoming"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Past rides tab
          _pastRides.isEmpty
              ? _buildEmptyState("No past rides", "Your completed rides will appear here")
              : _buildRidesList(_pastRides),
          
          // Upcoming rides tab
          _upcomingRides.isEmpty
              ? _buildEmptyState("No upcoming rides", "Your scheduled rides will appear here")
              : _buildRidesList(_upcomingRides, isUpcoming: true),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bike_outlined,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to map screen
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Find a Bike",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRidesList(List<Ride> rides, {bool isUpcoming = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return GestureDetector(
          onTap: () {
            _showRideDetails(ride);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                // Ride image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    ride.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Ride details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ride.bikeName,
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
                              ride.bikeType,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Ride time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isUpcoming
                                ? "Scheduled for ${DateFormat('MMM dd, yyyy • h:mm a').format(ride.startTime)}"
                                : "Completed on ${DateFormat('MMM dd, yyyy').format(ride.startTime)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Ride locations
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isUpcoming
                                  ? "Starting from ${ride.startLocation}"
                                  : "From ${ride.startLocation} to ${ride.endLocation}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      if (!isUpcoming) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        
                        // Ride stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildRideStat(
                              context,
                              icon: Icons.timer,
                              value: _formatDuration(ride.endTime!.difference(ride.startTime)),
                              label: "Duration",
                            ),
                            _buildRideStat(
                              context,
                              icon: Icons.straighten,
                              value: "${ride.distance!.toStringAsFixed(1)} km",
                              label: "Distance",
                            ),
                            _buildRideStat(
                              context,
                              icon: Icons.attach_money,
                              value: "\$${ride.cost!.toStringAsFixed(2)}",
                              label: "Cost",
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildRideStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
    } else {
      return "${duration.inMinutes}m";
    }
  }
  
  void _showRideDetails(Ride ride) {
    final bool isUpcoming = ride.endTime == null;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    ride.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ride title and type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ride.bikeName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ride.bikeType,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Ride status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUpcoming ? Icons.event : Icons.check_circle,
                            size: 16,
                            color: isUpcoming ? Colors.blue : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isUpcoming ? "Upcoming Ride" : "Completed",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isUpcoming ? Colors.blue : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Ride details
                    Text(
                      "Ride Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date and time
                    _buildDetailItem(
                      context,
                      icon: Icons.calendar_today,
                      title: "Date",
                      value: DateFormat('EEEE, MMMM dd, yyyy').format(ride.startTime),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildDetailItem(
                      context,
                      icon: Icons.access_time,
                      title: "Time",
                      value: isUpcoming
                          ? DateFormat('h:mm a').format(ride.startTime)
                          : "${DateFormat('h:mm a').format(ride.startTime)} - ${DateFormat('h:mm a').format(ride.endTime!)}",
                    ),
                    
                    if (!isUpcoming) ...[
                      const SizedBox(height: 16),
                      _buildDetailItem(
                        context,
                        icon: Icons.timer,
                        title: "Duration",
                        value: _formatDuration(ride.endTime!.difference(ride.startTime)),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Location details
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildDetailItem(
                      context,
                      icon: Icons.location_on,
                      title: "Start Location",
                      value: ride.startLocation,
                    ),
                    
                    if (!isUpcoming) ...[
                      const SizedBox(height: 16),
                      _buildDetailItem(
                        context,
                        icon: Icons.location_on,
                        title: "End Location",
                        value: ride.endLocation!,
                      ),
                      
                      const SizedBox(height: 16),
                      _buildDetailItem(
                        context,
                        icon: Icons.straighten,
                        title: "Distance",
                        value: "${ride.distance!.toStringAsFixed(1)} km",
                      ),
                    ],
                    
                    if (!isUpcoming) ...[
                      const SizedBox(height: 24),
                      
                      // Payment details
                      Text(
                        "Payment",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDetailItem(
                        context,
                        icon: Icons.credit_card,
                        title: "Payment Method",
                        value: "Visa •••• 4242",
                      ),
                      
                      const SizedBox(height: 16),
                      _buildDetailItem(
                        context,
                        icon: Icons.attach_money,
                        title: "Total Cost",
                        value: "\$${ride.cost!.toStringAsFixed(2)}",
                        valueColor: AppTheme.primaryColor,
                        valueFontWeight: FontWeight.bold,
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    
                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action based on ride status
                          if (isUpcoming) {
                            // Cancel upcoming ride
                          } else {
                            // Report issue or rate ride
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isUpcoming ? Colors.red : AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          isUpcoming ? "Cancel Reservation" : "Report an Issue",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: valueFontWeight ?? FontWeight.w500,
                  color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
