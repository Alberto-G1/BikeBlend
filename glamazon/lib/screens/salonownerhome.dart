import 'package:flutter/material.dart';
import 'package:glamazon/screens/customer_chats.dart';
import 'package:glamazon/screens/owner-gallery.dart';
import 'package:glamazon/screens/owner_profile_page.dart';
import 'package:glamazon/screens/settings_owner.dart';
import 'package:glamazon/screens/Salon%20Owner/analytics_page.dart';
import 'package:glamazon/screens/Salon%20Owner/appointment_management_page.dart';
import 'package:glamazon/screens/Salon%20Owner/manage_services_page.dart';
import 'package:glamazon/screens/owner_edit_profile_page.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'welcome_screen.dart';

class SalonOwnerHome extends StatefulWidget {
  const SalonOwnerHome({super.key});

  @override
  _SalonOwnerHomeState createState() => _SalonOwnerHomeState();
}

class _SalonOwnerHomeState extends State<SalonOwnerHome> {
  String salonId = '';
  String salonName = '';
  String location = '';
  String? profileImageUrl;
  bool _isLoading = true; // Added variable to manage loading state
  Map<String, dynamic> ownerData = {};
  List<Map<String, dynamic>> upcomingAppointments = [];
  List<Map<String, dynamic>> recentReviews = [];

  @override
  void initState() {
    super.initState();
    _fetchSalonDetails();
  }

  Future<void> _fetchSalonDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profileDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
        final data = profileDoc.data();
        if (data != null) {
          setState(() {
            salonId = profileDoc.id;
            salonName = data['salonName'] ?? 'Salon Name';
            location = data['location'] ?? 'Location';
            profileImageUrl = data['profileImageUrl'];
            ownerData = data;
          });
        }

        // Fetch upcoming appointments (mock data for now)
        upcomingAppointments = [
          {
            'clientName': 'Emma Johnson',
            'service': 'Hair Styling',
            'date': DateTime.now().add(const Duration(days: 1)),
            'time': '10:00 AM',
            'status': 'confirmed',
          },
          {
            'clientName': 'Michael Smith',
            'service': 'Beard Trim',
            'date': DateTime.now().add(const Duration(days: 2)),
            'time': '2:30 PM',
            'status': 'pending',
          },
          {
            'clientName': 'Sophia Williams',
            'service': 'Manicure',
            'date': DateTime.now().add(const Duration(days: 3)),
            'time': '11:15 AM',
            'status': 'confirmed',
          },
        ];

        // Fetch recent reviews (mock data for now)
        recentReviews = [
          {
            'userName': 'James Brown',
            'rating': 5,
            'comment': 'Excellent service! Very professional and friendly staff.',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
          },
          {
            'userName': 'Olivia Davis',
            'rating': 4,
            'comment': 'Great experience overall. Will definitely come back.',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
          },
        ];
      }
    } catch (e) {
      print('Error fetching salon details: $e');
      // Optionally, you can show an error message to the user
    } finally {
      setState(() {
        _isLoading = false; // Stop loading after fetching data
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode 
          ? const Color(0xFF121212) 
          : const Color.fromARGB(255, 248, 236, 220),
      appBar: AppBar(
        title: const Text(
          'Salon Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Owner Profile Card
                  _buildOwnerProfileCard(isDarkMode),

                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildSectionTitle('Quick Actions', isDarkMode),
                  const SizedBox(height: 16),
                  _buildQuickActionsGrid(isDarkMode),

                  const SizedBox(height: 24),

                  // Upcoming Appointments
                  _buildSectionTitle('Upcoming Appointments', isDarkMode),
                  const SizedBox(height: 16),
                  _buildUpcomingAppointments(isDarkMode),

                  const SizedBox(height: 24),

                  // Recent Reviews
                  _buildSectionTitle('Recent Reviews', isDarkMode),
                  const SizedBox(height: 16),
                  _buildRecentReviews(isDarkMode),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildOwnerProfileCard(bool isDarkMode) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      )
                    : Container(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: Icon(
                          Icons.business,
                          size: 40,
                          color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Salon Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salonName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ownerData['ownerName'] ?? 'Salon Owner',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // View Profile Button
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              tooltip: 'View Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionCard(
          title: 'Manage Profile',
          icon: Icons.person,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            );
          },
          isDarkMode: isDarkMode,
        ),
        _buildActionCard(
          title: 'Manage Services',
          icon: Icons.spa,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageServicesPage()),
            );
          },
          isDarkMode: isDarkMode,
        ),
        _buildActionCard(
          title: 'Appointments',
          icon: Icons.calendar_today,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppointmentManagementPage()),
            );
          },
          isDarkMode: isDarkMode,
        ),
        _buildActionCard(
          title: 'Analytics',
          icon: Icons.bar_chart,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsPage()),
            );
          },
          isDarkMode: isDarkMode,
        ),
        _buildActionCard(
          title: 'Gallery',
          icon: Icons.photo_album_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SalonDetails()),
            );
          },
          isDarkMode: isDarkMode,
        ),
        _buildActionCard(
          title: 'Chat Room',
          icon: Icons.chat,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OwnerChatMainPage(
                  salonId: salonId,
                  salonName: salonName,
                  salonProfileImageUrl: profileImageUrl ?? '',
                ),
              ),
            );
          },
          isDarkMode: isDarkMode,
        ),
        _buildActionCard(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsOwner()),
            );
          },
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? AppColors.sienna.withOpacity(0.2) 
                      : AppColors.sienna.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments(bool isDarkMode) {
    if (upcomingAppointments.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No upcoming appointments',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: upcomingAppointments.map((appointment) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Container
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.sienna.withOpacity(0.2) : AppColors.sienna.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd').format(appointment['date']),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(appointment['date']),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Appointment Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['clientName'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['service'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment['time'],
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: appointment['status'] == 'confirmed'
                        ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                        : Colors.orange.withOpacity(isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    appointment['status'] == 'confirmed' ? 'Confirmed' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: appointment['status'] == 'confirmed'
                          ? Colors.green[isDarkMode ? 300 : 700]
                          : Colors.orange[isDarkMode ? 300 : 700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentReviews(bool isDarkMode) {
    if (recentReviews.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No reviews yet',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentReviews.map((review) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDarkMode ? AppColors.siennaLight.withOpacity(0.2) : AppColors.sienna.withOpacity(0.2),
                      child: Text(
                        (review['userName'] ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['userName'] ?? 'Anonymous',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (review['timestamp'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(review['timestamp']),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (review['rating'] ?? 0) ? Icons.star : Icons.star_border,
                          color: index < (review['rating'] ?? 0) ? Colors.amber : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
                          size: 18,
                        );
                      }),
                    ),
                  ],
                ),
                if (review['comment'] != null && review['comment'].isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    review['comment'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: isDarkMode 
                ? AppColors.siennaLight.withOpacity(0.3) 
                : AppColors.sienna.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Recent';
  }
}

// import 'package:flutter/material.dart';
// import 'package:glamazon/screens/customer_chats.dart';
// import 'package:glamazon/screens/owner-gallery.dart';
// import 'package:glamazon/screens/Salon%20Owner/analytics_page.dart';
// import 'package:glamazon/screens/Salon%20Owner/manage_services_page.dart';
// import 'package:glamazon/screens/owner_edit_profile_page.dart';
// import 'package:glamazon/screens/owner_profile_page.dart';
// import 'package:glamazon/screens/welcome_screen.dart';
// import 'package:glamazon/screens/appointments_page.dart';
// import 'package:glamazon/screens/notifications.dart';
// import 'package:glamazon/config/theme/theme_provider.dart';
// import 'package:glamazon/utils/colors.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:intl/intl.dart';

// class SalonOwnerHome extends StatefulWidget {
//   const SalonOwnerHome({super.key});

//   @override
//   State<SalonOwnerHome> createState() => _SalonOwnerHomeState();
// }

// class _SalonOwnerHomeState extends State<SalonOwnerHome> {
//   bool isLoading = true;
//   Map<String, dynamic> ownerData = {};
//   List<Map<String, dynamic>> upcomingAppointments = [];
//   List<Map<String, dynamic>> recentReviews = [];
  
//   @override
//   void initState() {
//     super.initState();
//     _fetchOwnerData();
//   }
  
//   Future<void> _fetchOwnerData() async {
//     setState(() {
//       isLoading = true;
//     });
    
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Fetch owner profile data
//         final ownerDoc = await FirebaseFirestore.instance
//             .collection('owners')
//             .doc(user.uid)
//             .get();
            
//         if (ownerDoc.exists) {
//           ownerData = ownerDoc.data() ?? {};
//         }
        
//         // Fetch upcoming appointments
//         // In a real app, you would fetch from Firestore with a proper query
//         try {
//           final appointmentsSnapshot = await FirebaseFirestore.instance
//               .collection('appointments')
//               .where('salonId', isEqualTo: user.uid)
//               .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
//               .orderBy('date')
//               .limit(5)
//               .get();
              
//           if (appointmentsSnapshot.docs.isNotEmpty) {
//             upcomingAppointments = appointmentsSnapshot.docs
//                 .map((doc) => {
//                       ...doc.data(),
//                       'id': doc.id,
//                     })
//                 .toList();
//           } else {
//             // Fallback to mock data if no appointments found
//             upcomingAppointments = [
//               {
//                 'clientName': 'Emma Johnson',
//                 'service': 'Hair Styling',
//                 'date': DateTime.now().add(const Duration(days: 1)),
//                 'time': '10:00 AM',
//                 'status': 'confirmed',
//               },
//               {
//                 'clientName': 'Michael Smith',
//                 'service': 'Beard Trim',
//                 'date': DateTime.now().add(const Duration(days: 2)),
//                 'time': '2:30 PM',
//                 'status': 'pending',
//               },
//               {
//                 'clientName': 'Sophia Williams',
//                 'service': 'Manicure',
//                 'date': DateTime.now().add(const Duration(days: 3)),
//                 'time': '11:15 AM',
//                 'status': 'confirmed',
//               },
//             ];
//           }
//         } catch (e) {
//           print('Error fetching appointments: $e');
//           // Fallback to mock data
//           upcomingAppointments = [
//             {
//               'clientName': 'Emma Johnson',
//               'service': 'Hair Styling',
//               'date': DateTime.now().add(const Duration(days: 1)),
//               'time': '10:00 AM',
//               'status': 'confirmed',
//             },
//             {
//               'clientName': 'Michael Smith',
//               'service': 'Beard Trim',
//               'date': DateTime.now().add(const Duration(days: 2)),
//               'time': '2:30 PM',
//               'status': 'pending',
//             },
//           ];
//         }
        
//         // Fetch recent reviews
//         // In a real app, you would fetch from Firestore with a proper query
//         try {
//           final reviewsSnapshot = await FirebaseFirestore.instance
//               .collection('reviews')
//               .where('salonId', isEqualTo: user.uid)
//               .orderBy('timestamp', descending: true)
//               .limit(3)
//               .get();
              
//           if (reviewsSnapshot.docs.isNotEmpty) {
//             recentReviews = reviewsSnapshot.docs
//                 .map((doc) => {
//                       ...doc.data(),
//                       'id': doc.id,
//                     })
//                 .toList();
//           } else {
//             // Fallback to mock data if no reviews found
//             recentReviews = [
//               {
//                 'userName': 'James Brown',
//                 'rating': 5,
//                 'comment': 'Excellent service! Very professional and friendly staff.',
//                 'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
//               },
//               {
//                 'userName': 'Olivia Davis',
//                 'rating': 4,
//                 'comment': 'Great experience overall. Will definitely come back.',
//                 'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
//               },
//             ];
//           }
//         } catch (e) {
//           print('Error fetching reviews: $e');
//           // Fallback to mock data
//           recentReviews = [
//             {
//               'userName': 'James Brown',
//               'rating': 5,
//               'comment': 'Excellent service! Very professional and friendly staff.',
//               'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
//             },
//             {
//               'userName': 'Olivia Davis',
//               'rating': 4,
//               'comment': 'Great experience overall. Will definitely come back.',
//               'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
//             },
//           ];
//         }
//       }
//     } catch (e) {
//       print('Error fetching owner data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching data: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
  
//   Future<void> _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error signing out: $e')),
//       );
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
    
//     return Scaffold(
//       backgroundColor: isDarkMode 
//           ? const Color(0xFF121212) 
//           : const Color.fromARGB(255, 248, 236, 220),
//       appBar: AppBar(
//         title: const Text(
//           'Salon Dashboard',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               isDarkMode ? Icons.light_mode : Icons.dark_mode,
//             ),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//             tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationsPage()),
//               );
//             },
//             tooltip: 'Notifications',
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _signOut,
//             tooltip: 'Sign Out',
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//               ),
//             )
//           : RefreshIndicator(
//               onRefresh: _fetchOwnerData,
//               color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Owner Profile Card
//                     _buildOwnerProfileCard(isDarkMode),
                    
//                     const SizedBox(height: 24),
                    
//                     // Quick Actions
//                     _buildSectionTitle('Quick Actions', isDarkMode),
//                     const SizedBox(height: 16),
//                     _buildQuickActionsGrid(isDarkMode),
                    
//                     const SizedBox(height: 24),
                    
//                     // Upcoming Appointments
//                     _buildSectionTitle('Upcoming Appointments', isDarkMode),
//                     const SizedBox(height: 16),
//                     _buildUpcomingAppointments(isDarkMode),
                    
//                     const SizedBox(height: 24),
                    
//                     // Recent Reviews
//                     _buildSectionTitle('Recent Reviews', isDarkMode),
//                     const SizedBox(height: 16),
//                     _buildRecentReviews(isDarkMode),
                    
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
  
//   Widget _buildOwnerProfileCard(bool isDarkMode) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             // Profile Image
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                   width: 2,
//                 ),
//               ),
//               child: ClipOval(
//                 child: ownerData['profileImageUrl'] != null && ownerData['profileImageUrl'].isNotEmpty
//                     ? CachedNetworkImage(
//                         imageUrl: ownerData['profileImageUrl'],
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Container(
//                           color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                           child: const Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                           child: const Icon(Icons.error),
//                         ),
//                       )
//                     : Container(
//                         color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
//                         child: Icon(
//                           Icons.business,
//                           size: 40,
//                           color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Salon Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     ownerData['salonName'] ?? 'Your Salon',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? Colors.white : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     ownerData['ownerName'] ?? 'Salon Owner',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: isDarkMode ? Colors.white70 : Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           ownerData['location'] ?? 'Location not set',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isDarkMode ? Colors.white70 : Colors.black54,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // View Profile Button
//             IconButton(
//               icon: Icon(
//                 Icons.arrow_forward_ios,
//                 size: 20,
//                 color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ProfilePage()),
//                 );
//               },
//               tooltip: 'View Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildQuickActionsGrid(bool isDarkMode) {
//     return GridView.count(
//       crossAxisCount: 2,
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       children: [
//         _buildActionCard(
//           title: 'Manage Profile',
//           icon: Icons.person,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const EditProfilePage()),
//             );
//           },
//           isDarkMode: isDarkMode,
//         ),
//         _buildActionCard(
//           title: 'Manage Services',
//           icon: Icons.spa,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ManageServicesPage()),
//             );
//           },
//           isDarkMode: isDarkMode,
//         ),
//         _buildActionCard(
//           title: 'Appointments',
//           icon: Icons.calendar_today,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AppointmentsPage()),
//             );
//           },
//           isDarkMode: isDarkMode,
//         ),
//         _buildActionCard(
//           title: 'Analytics',
//           icon: Icons.bar_chart,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AnalyticsPage()),
//             );
//           },
//           isDarkMode: isDarkMode,
//         ),
//         _buildActionCard(
//           title: 'Gallery',
//           icon: Icons.photo_library,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SalonDetails()),
//             );
//           },
//           isDarkMode: isDarkMode,
//         ),
//         _buildActionCard(
//           title: 'Chat Room',
//           icon: Icons.chat,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OwnerChatMainPage(
//                   salonId: FirebaseAuth.instance.currentUser?.uid ?? '',
//                   salonName: ownerData['salonName'] ?? 'Your Salon',
//                   salonProfileImageUrl: ownerData['profileImageUrl'] ?? '',
//                 ),
//               ),
//             );
//           },
//           isDarkMode: isDarkMode,
//         ),
//       ],
//     );
//   }
  
//   Widget _buildActionCard({
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//     required bool isDarkMode,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                        ? AppColors.sienna.withOpacity(0.2)
//                        : AppColors.sienna.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   icon,
//                   color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: isDarkMode ? Colors.white : Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildUpcomingAppointments(bool isDarkMode) {
//     if (upcomingAppointments.isEmpty) {
//       return Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.event_busy,
//                   size: 48,
//                   color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No upcoming appointments',
//                   style: TextStyle(
//                     color: isDarkMode ? Colors.white70 : Colors.black54,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
    
//     return Column(
//       children: [
//         ...upcomingAppointments.map((appointment) {
//           // Format date properly based on the type
//           DateTime appointmentDate;
//           if (appointment['date'] is DateTime) {
//             appointmentDate = appointment['date'];
//           } else if (appointment['date'] is Timestamp) {
//             appointmentDate = (appointment['date'] as Timestamp).toDate();
//           } else {
//             appointmentDate = DateTime.now(); // Fallback
//           }
          
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Date Container
//                   Container(
//                     width: 60,
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     decoration: BoxDecoration(
//                       color: isDarkMode ? AppColors.sienna.withOpacity(0.2) : AppColors.sienna.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           DateFormat('dd').format(appointmentDate),
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                           ),
//                         ),
//                         Text(
//                           DateFormat('MMM').format(appointmentDate),
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   // Appointment Details
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           appointment['clientName'] ?? 'Client',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isDarkMode ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           appointment['service'] ?? 'Service',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isDarkMode ? Colors.white70 : Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.access_time,
//                               size: 16,
//                               color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               appointment['time'] ?? 'Time not set',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Status Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: (appointment['status'] == 'confirmed')
//                           ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
//                           : Colors.orange.withOpacity(isDarkMode ? 0.2 : 0.1),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(
//                       (appointment['status'] == 'confirmed') ? 'Confirmed' : 'Pending',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: (appointment['status'] == 'confirmed')
//                             ? Colors.green[isDarkMode ? 300 : 700]
//                             : Colors.orange[isDarkMode ? 300 : 700],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
        
//         // View All Button
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AppointmentsPage()),
//             );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'View All Appointments',
//                 style: TextStyle(
//                   color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Icon(
//                 Icons.arrow_forward,
//                 size: 16,
//                 color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildRecentReviews(bool isDarkMode) {
//     if (recentReviews.isEmpty) {
//       return Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.rate_review_outlined,
//                   size: 48,
//                   color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No reviews yet',
//                   style: TextStyle(
//                     color: isDarkMode ? Colors.white70 : Colors.black54,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
    
//     return Column(
//       children: [
//         ...recentReviews.map((review) {
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: isDarkMode ? AppColors.siennaLight.withOpacity(0.2) : AppColors.sienna.withOpacity(0.2),
//                         child: Text(
//                           (review['userName'] ?? 'U')[0].toUpperCase(),
//                           style: TextStyle(
//                             color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               review['userName'] ?? 'Anonymous',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDarkMode ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                             if (review['timestamp'] != null) ...[
//                               const SizedBox(height: 2),
//                               Text(
//                                 _formatDate(review['timestamp']),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                       Row(
//                         children: List.generate(5, (index) {
//                           return Icon(
//                             index < (review['rating'] ?? 0) ? Icons.star : Icons.star_border,
//                             color: index < (review['rating'] ?? 0) ? Colors.amber : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
//                             size: 18,
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                   if (review['comment'] != null && review['comment'].isNotEmpty) ...[
//                     const SizedBox(height: 12),
//                     Text(
//                       review['comment'],
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isDarkMode ? Colors.white70 : Colors.black87,
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
        
//         // View All Button (you can create a reviews page later)
//         TextButton(
//           onPressed: () {
//             // Navigate to a reviews page
//             // For now, just show a snackbar
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Reviews page coming soon!')),
//             );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'View All Reviews',
//                 style: TextStyle(
//                   color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Icon(
//                 Icons.arrow_forward,
//                 size: 16,
//                 color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildSectionTitle(String title, bool isDarkMode) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Divider(
//             color: isDarkMode
//                  ? AppColors.siennaLight.withOpacity(0.3)
//                  : AppColors.sienna.withOpacity(0.3),
//             thickness: 1,
//           ),
//         ),
//       ],
//     );
//   }
  
//   String _formatDate(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       final date = timestamp.toDate();
//       return DateFormat('MMM d, yyyy').format(date);
//     }
//     return 'Recent';
//   }
// }
