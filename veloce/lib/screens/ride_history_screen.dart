import 'package:flutter/material.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Sample ride history data
    final rides = [
      {
        "id": "RD-1234",
        "from": "Main Street",
        "to": "Park Avenue",
        "distance": "2.1 km",
        "duration": "15 min",
        "fare": "\$2.50",
        "time": "Apr 12, 4:35 PM",
        "bikeType": "Mountain Bike",
        "status": "Completed"
      },
      {
        "id": "RD-1235",
        "from": "Hill View",
        "to": "Market Square",
        "distance": "3.5 km",
        "duration": "22 min",
        "fare": "\$3.75",
        "time": "Apr 10, 2:10 PM",
        "bikeType": "City Bike",
        "status": "Completed"
      },
      {
        "id": "RD-1236",
        "from": "Central Park",
        "to": "Downtown",
        "distance": "4.2 km",
        "duration": "28 min",
        "fare": "\$4.20",
        "time": "Apr 8, 10:15 AM",
        "bikeType": "Electric Bike",
        "status": "Completed"
      },
      {
        "id": "RD-1237",
        "from": "Riverside",
        "to": "University Campus",
        "distance": "1.8 km",
        "duration": "12 min",
        "fare": "\$2.00",
        "time": "Apr 5, 9:22 AM",
        "bikeType": "Road Bike",
        "status": "Completed"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride History"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats summary card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Riding Stats",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          "11.6 km",
                          "Total Distance",
                          Icons.straighten,
                        ),
                        _buildStatItem(
                          context,
                          "77 min",
                          "Total Time",
                          Icons.timer,
                        ),
                        _buildStatItem(
                          context,
                          "\$12.45",
                          "Total Spent",
                          Icons.attach_money,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Rides list header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Rides",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show all rides
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Rides list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rides.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ride = rides[index];
                return _buildRideCard(context, ride, theme, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildRideCard(BuildContext context, Map<String, String> ride, ThemeData theme, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _showRideDetails(context, ride);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Ride header with time and ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pedal_bike,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ride["bikeType"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    ride["time"]!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Route visualization
              Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                      Container(
                        width: 2,
                        height: 30,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride["from"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          ride["to"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Ride details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black12 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRideDetail(
                      context,
                      ride["distance"]!,
                      "Distance",
                      Icons.straighten,
                    ),
                    _buildRideDetail(
                      context,
                      ride["duration"]!,
                      "Duration",
                      Icons.timer,
                    ),
                    _buildRideDetail(
                      context,
                      ride["fare"]!,
                      "Fare",
                      Icons.attach_money,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRideDetail(
    BuildContext context,
    String value,
    String label,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isHighlighted ? theme.colorScheme.primary : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isHighlighted ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  void _showRideDetails(BuildContext context, Map<String, String> ride) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ride Details",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Ride ID and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ride ID: ${ride["id"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(ride["time"]!),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Route visualization
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      Container(
                        width: 2,
                        height: 50,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride["from"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "To",
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride["to"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Ride details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Bike Type", ride["bikeType"]!),
                    const SizedBox(height: 12),
                    _buildDetailRow("Distance", ride["distance"]!),
                    const SizedBox(height: 12),
                    _buildDetailRow("Duration", ride["duration"]!),
                    const SizedBox(height: 12),
                    _buildDetailRow("Status", ride["status"]!),
                    _buildDetailRow("Status", ride["status"]!),
                    const SizedBox(height: 12),
                    _buildDetailRow("Fare", ride["fare"]!, isHighlighted: true),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Receipt downloaded"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long),
                      label: const Text("Receipt"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Support request sent"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.support_agent),
                      label: const Text("Support"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isHighlighted ? Colors.green[700] : null,
          ),
        ),
      ],
    );
  }
  
  void _showFilterDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Filter Rides",
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Date Range"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Show date picker
                      },
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: const Text("From"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Show date picker
                      },
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: const Text("To"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              const Text("Bike Type"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text("All"),
                    selected: true,
                    onSelected: (selected) {},
                    backgroundColor: Colors.grey[200],
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  FilterChip(
                    label: const Text("Mountain"),
                    selected: false,
                    onSelected: (selected) {},
                    backgroundColor: Colors.grey[200],
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  FilterChip(
                    label: const Text("City"),
                    selected: false,
                    onSelected: (selected) {},
                    backgroundColor: Colors.grey[200],
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  FilterChip(
                    label: const Text("Electric"),
                    selected: false,
                    onSelected: (selected) {},
                    backgroundColor: Colors.grey[200],
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              const Text("Sort By"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: "Recent",
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(value: "Recent", child: Text("Most Recent")),
                  DropdownMenuItem(value: "Oldest", child: Text("Oldest First")),
                  DropdownMenuItem(value: "Distance", child: Text("Distance (High to Low)")),
                  DropdownMenuItem(value: "Fare", child: Text("Fare (High to Low)")),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }
}
