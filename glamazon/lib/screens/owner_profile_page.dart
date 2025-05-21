import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:glamazon/screens/salon_profile_details_page.dart';
import 'package:glamazon/screens/salonownerhome.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? profileImageUrl;
  String salonName = '';
  String location = '';
  String ownerName = '';
  String contact = '';
  String email = '';
  String workingDays = '';
  String workingHours = '';
  String salonDescription = '';
  bool isLoading = true;
  
  Map<String, bool> servicesOffered = {
    'Hair styling and Cuts': false,
    'Nails': false,
    'Spa or Massage': false,
    'Tattoo': false,
    'Facial and Makeup': false,
    'Piercing': false,
  };
  
  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isLoading = true;
    });
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    try {
      final profileDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
      final data = profileDoc.data();
      
      if (data != null) {
        setState(() {
          profileImageUrl = data['profileImageUrl'];
          salonName = data['salonName'] ?? '';
          location = data['location'] ?? '';
          ownerName = data['ownerName'] ?? '';
          contact = data['contact'] ?? '';
          email = data['email'] ?? '';
          workingDays = data['workingDays'] ?? 'Monday to Saturday';
          workingHours = data['workingHours'] ?? '';
          salonDescription = data['salonDescription'] ?? 'No description available';
          
          if (data['servicesOffered'] != null) {
            servicesOffered = Map<String, bool>.from(data['servicesOffered']);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
          'Salon Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/edit-profile');
              if (result != null) {
                _fetchProfileData();
              }
            },
          ),
        ],
      ),
      body: isLoading 
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchProfileData,
              color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header with Salon Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Profile Image
                            Hero(
                              tag: 'profile-image',
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: profileImageUrl!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error),
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/default.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Salon Name
                            Text(
                              salonName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Location with icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Profile Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildQuickAction(
                                context,
                                Icons.info_outline,
                                'Details',
                                () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => SalonDetailsPage(
                                  //       salonId: FirebaseAuth.instance.currentUser!.uid, salon: ,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                isDarkMode,
                              ),
                              _buildQuickAction(
                                context,
                                Icons.edit_calendar,
                                'Schedule',
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Schedule management coming soon')),
                                  );
                                },
                                isDarkMode,
                              ),
                              _buildQuickAction(
                                context,
                                Icons.home,
                                'Dashboard',
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SalonOwnerHome()),
                                  );
                                },
                                isDarkMode,
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Owner Information Section
                          _buildSectionTitle('Owner Information', isDarkMode),
                          const SizedBox(height: 12),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    Icons.person,
                                    'Owner\'s Name',
                                    ownerName,
                                    isDarkMode,
                                  ),
                                  const Divider(),
                                  _buildInfoRow(
                                    Icons.phone,
                                    'Contact',
                                    contact,
                                    isDarkMode,
                                  ),
                                  const Divider(),
                                  _buildInfoRow(
                                    Icons.email,
                                    'Email',
                                    email,
                                    isDarkMode,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Business Hours Section
                          _buildSectionTitle('Business Hours', isDarkMode),
                          const SizedBox(height: 12),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    Icons.calendar_today,
                                    'Working Days',
                                    workingDays,
                                    isDarkMode,
                                  ),
                                  const Divider(),
                                  _buildInfoRow(
                                    Icons.access_time,
                                    'Working Hours',
                                    workingHours,
                                    isDarkMode,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Services Section
                          _buildSectionTitle('Services Offered', isDarkMode),
                          const SizedBox(height: 12),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...servicesOffered.entries
                                      .where((entry) => entry.value)
                                      .map((entry) => _buildServiceItem(entry.key, isDarkMode))
                                      .toList(),
                                  if (servicesOffered.entries.where((entry) => entry.value).isEmpty)
                                    Text(
                                      'No services added yet',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Description Section
                          _buildSectionTitle('About Salon', isDarkMode),
                          const SizedBox(height: 12),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                salonDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode ? Colors.white70 : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Edit Profile Button
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(context, '/edit-profile');
                                if (result != null) {
                                  _fetchProfileData();
                                }
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalonOwnerHome()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Go to Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'Not specified' : value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String service, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            service,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
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
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
