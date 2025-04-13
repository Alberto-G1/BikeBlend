import 'package:flutter/material.dart';
import 'package:bike_bliss/theme/app_theme.dart';
import 'package:bike_bliss/widgets/bike_card.dart';
import 'package:bike_bliss/widgets/promotion_card.dart';
import 'package:bike_bliss/models/bike.dart';
import 'package:bike_bliss/models/promotion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Bike> _nearbyBikes = [
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
  ];
  
  final List<Promotion> _promotions = [
    Promotion(
      id: '1',
      title: 'Weekend Special',
      description: 'Get 30% off on all rides this weekend!',
      imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YmlrZSUyMHJpZGV8ZW58MHx8MHx8&w=1000&q=80',
      validUntil: DateTime.now().add(const Duration(days: 3)),
      discount: 30,
    ),
    Promotion(
      id: '2',
      title: 'First Ride Free',
      description: 'New users get their first 30-minute ride free!',
      imageUrl: 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YmlrZSUyMHJpZGV8ZW58MHx8MHx8&w=1000&q=80',
      validUntil: DateTime.now().add(const Duration(days: 30)),
      discount: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // App bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Alex!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "New York City",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).cardColor,
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Search bar
                  Container(
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for bikes or locations",
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
                  
                  const SizedBox(height: 30),
                  
                  // Quick actions
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickActionCard(
                        context,
                        icon: Icons.qr_code_scanner,
                        title: "Scan QR",
                        onTap: () {
                          // Navigate to scan screen
                        },
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.map,
                        title: "Find Bikes",
                        onTap: () {
                          // Navigate to map screen
                        },
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.history,
                        title: "My Rides",
                        onTap: () {
                          // Navigate to rides screen
                        },
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.card_giftcard,
                        title: "Rewards",
                        onTap: () {
                          // Navigate to rewards screen
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Promotions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Special Offers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all promotions
                        },
                        child: Text(
                          "See All",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _promotions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == _promotions.length - 1 ? 0 : 15,
                          ),
                          child: PromotionCard(promotion: _promotions[index]),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Nearby bikes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nearby Bikes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to map screen
                        },
                        child: Text(
                          "View Map",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _nearbyBikes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _nearbyBikes.length - 1 ? 0 : 15,
                        ),
                        child: BikeCard(bike: _nearbyBikes[index]),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 15),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
