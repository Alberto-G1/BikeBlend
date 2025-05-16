import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/reusable_widgets/custom_app_bar.dart';
import 'package:glamazon/screens/customer-home.dart';
import 'package:glamazon/screens/customer_profile-edit.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  // bool _isLoading = true;
  bool _animate = false;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _animate = true;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color.fromARGB(255, 248, 236, 220),
      appBar: CustomAppBar(
        title: 'Profile',
        backgroundColor: isDarkMode ? Colors.black : AppColors.sienna,
        showThemeToggle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
              ),
            );
          }
          
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Profile not found',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.teal.shade700 : AppColors.sienna,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Create Profile'),
                  ),
                ],
              ),
            );
          }
          
          // Extract user data
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final username = userData['username'] ?? 'User';
          final email = userData['email'] ?? '';
          final phone = userData['phone'] ?? '';
          final bio = userData['bio'] ?? 'No bio available';
          final address = userData['address'] ?? '';
          final profilePicture = userData['profile_picture'] ?? '';
          final gender = userData['gender'] ?? 'Not specified';
          
          // Get birth date if available
          DateTime? birthDate;
          if (userData['birth_date'] != null) {
            birthDate = DateTime.fromMillisecondsSinceEpoch(userData['birth_date']);
          }
          
          // Get preferences if available
          List<String> preferences = [];
          if (userData['preferences'] != null) {
            preferences = List<String>.from(userData['preferences']);
          }
          
          return Stack(
            children: [
              // Background header
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : AppColors.sienna,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              
              // Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile picture
                      AppAnimations.scale(
                        animate: _animate,
                        delay: const Duration(milliseconds: 300),
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[800] : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            image: profilePicture.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(profilePicture),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: profilePicture.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 70,
                                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                                )
                              : null,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Username
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          username,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Email
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 500),
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Basic information card
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 600),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Basic Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : AppColors.sienna,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Phone
                                _buildInfoRow(
                                  icon: Icons.phone_outlined,
                                  title: 'Phone',
                                  value: phone.isNotEmpty ? phone : 'Not provided',
                                  isDarkMode: isDarkMode,
                                ),
                                
                                const Divider(height: 24),
                                
                                // Gender
                                _buildInfoRow(
                                  icon: Icons.person_outline,
                                  title: 'Gender',
                                  value: gender,
                                  isDarkMode: isDarkMode,
                                ),
                                
                                if (birthDate != null) ...[
                                  const Divider(height: 24),
                                  
                                  // Birth date
                                  _buildInfoRow(
                                    icon: Icons.calendar_today,
                                    title: 'Birth Date',
                                    value: DateFormat('MMMM d, yyyy').format(birthDate),
                                    isDarkMode: isDarkMode,
                                  ),
                                ],
                                
                                if (address.isNotEmpty) ...[
                                  const Divider(height: 24),
                                  
                                  // Address
                                  _buildInfoRow(
                                    icon: Icons.location_on_outlined,
                                    title: 'Address',
                                    value: address,
                                    isDarkMode: isDarkMode,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Bio card
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 700),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About Me',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : AppColors.sienna,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  bio,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      if (preferences.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        
                        // Preferences card
                        AppAnimations.slideIn(
                          animate: _animate,
                          beginOffset: const Offset(0, 0.2),
                          delay: const Duration(milliseconds: 800),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Beauty Preferences',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : AppColors.sienna,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: preferences.map((preference) {
                                      return Chip(
                                        label: Text(preference),
                                        backgroundColor: isDarkMode ? Colors.teal.shade800 : AppColors.sienna.withOpacity(0.7),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Sign out button
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 900),
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await _auth.signOut();
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const ImageSlider()),
                                (route) => false,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.logout,
                            color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
                          ),
                          label: Text(
                            'Sign Out',
                            style: TextStyle(
                              color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: isDarkMode ? Colors.grey[400] : AppColors.sienna,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:glamazon/screens/customer-home.dart';
// import 'package:glamazon/screens/customer_profile-edit.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 248, 236, 220),
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('users')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('User data not found'));
//           }

//           final userData = snapshot.data!.data() as Map<String, dynamic>;
//           final profilePicUrl = userData['profile_picture'] ?? 'assets/images/default_profile.png';
//           final username = userData['username'] ?? 'No Username';
//           final email = userData['email'] ?? 'No Email';
//           final phone = userData['phone'] ?? 'No Phone';

//           return Center(
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundImage: profilePicUrl.startsWith('assets/')
//                             ? AssetImage(profilePicUrl) as ImageProvider
//                             : NetworkImage(profilePicUrl),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         username,
//                         style: const TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         email,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         phone,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   right: 16,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown, // Background color of the button
//                       foregroundColor: Colors.white, // Text color of the button
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10), // Rounded corners
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const ImageSlider()),
//                       );
//                     },
//                     child: const Text('Continue to Home'),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
