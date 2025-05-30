import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/config/theme/theme_toggle.dart';
import 'package:glamazon/reusable_widgets/smooth_page_indicator.dart';
import 'package:glamazon/screens/settings_page.dart';
import 'package:glamazon/screens/welcome_screen.dart';
import 'package:glamazon/screens/customer_profile-details.dart';
import 'package:glamazon/screens/salon_list.dart';
import 'package:glamazon/screens/user_appointments.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> with SingleTickerProviderStateMixin {
  final PageController _carouselController = PageController();
  final List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'assets/images/spa/spa1.jpg',
      'title': 'Relaxing Spa Treatments',
      'description': 'Unwind with our premium spa services'
    },
    {
      'image': 'assets/images/nails/images (2).jpeg',
      'title': 'Professional Nail Art',
      'description': 'Express yourself with stunning nail designs'
    },
    {
      'image': 'assets/images/hair/haircut.jpeg',
      'title': 'Expert Hair Styling',
      'description': 'Transform your look with our skilled stylists'
    },
    {
      'image': 'assets/images/piercing/peircing1.webp',
      'title': 'Safe Piercing Services',
      'description': 'Professional piercing with sterile equipment'
    },
    {
      'image': 'assets/images/tatoo/tattoo 1.jpg',
      'title': 'Creative Tattoo Artists',
      'description': 'Bring your ideas to life with our talented artists'
    },
    {
      'image': 'assets/images/makeup/image03.jpg',
      'title': 'Glamorous Makeup',
      'description': 'Look your best for any special occasion'
    },
  ];
  
  final List<Map<String, dynamic>> services = [
    {
      'image': 'assets/images/hair/images (8).jpeg',
      'title': 'Hair Styling & Cuts',
      'description': 'Professional haircuts, coloring, and styling services'
    },
    {
      'image': 'assets/images/nails/image02.jpg',
      'title': 'Nail Services',
      'description': 'Manicures, pedicures, and nail art by experts'
    },
    {
      'image': 'assets/images/spa/spa.jpg',
      'title': 'Spa & Wellness',
      'description': 'Relaxing massages, facials, and body treatments'
    },
    {
      'image': 'assets/images/tatoo/image14.jpeg',
      'title': 'Tattoo Art',
      'description': 'Custom tattoo designs by professional artists'
    },
    {
      'image': 'assets/images/makeup/makeup2.jpeg',
      'title': 'Makeup & Facial',
      'description': 'Professional makeup application and skincare'
    },
    {
      'image': 'assets/images/piercing/piercing 2.jpg',
      'title': 'Body Piercing',
      'description': 'Safe and professional body piercing services'
    },
  ];
  
  int currentCarouselIndex = 0;
  bool _animate = false;
  late AnimationController _animationController;
  bool hasNewNotifications = true; // Set to true to show notification dot
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  // List<Map<String, dynamic>> _upcomingAppointments = [];

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
    
    // Fetch user data
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
            
        if (doc.exists) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _carouselController.dispose();
    super.dispose();
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
        backgroundColor: isDarkMode 
           ? AppColors.siennaDark
           : AppColors.sienna,
        elevation: 0,
        title: AppAnimations.fadeIn(
          animate: _animate,
          delay: const Duration(milliseconds: 200),
          child: const Text(
            'Glamazon',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white, // Always white for contrast
            ),
          ),
        ),
        actions: [
          // Notification icon with dot indicator
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // Handle notifications
                  setState(() {
                    hasNewNotifications = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('No new notifications'),
                      backgroundColor: isDarkMode ? AppColors.sienna : AppColors.sienna,
                    ),
                  );
                },
              ),
              if (hasNewNotifications)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          ThemeToggle(iconColor: Colors.white),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, isDarkMode),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.sienna,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and quick actions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppAnimations.scale(
                      animate: _animate,
                      child: Image.asset(
                        'assets/images/logo3.png',
                        height: 80,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQuickActionButton(
                          icon: Icons.calendar_today,
                          label: 'Appointments',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserAppointmentsPage()),
                            );
                          },
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 16),
                        _buildQuickActionButton(
                          icon: Icons.person,
                          label: 'Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfileScreen()),
                            );
                          },
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Welcome message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppAnimations.slideIn(
                  animate: _animate,
                  beginOffset: const Offset(0.5, 0),
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Welcome back, ${userData['username'] ?? 'User'}!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Featured carousel
              AppAnimations.fadeIn(
                animate: _animate,
                delay: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: 220,
                        autoPlayCurve: Curves.easeInOutCubic,
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayInterval: const Duration(seconds: 4),
                        enlargeCenterPage: true,
                        viewportFraction: 0.85,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentCarouselIndex = index;
                          });
                        },
                      ),
                      items: carouselItems.map((item) => _buildCarouselItem(item, isDarkMode)).toList(),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSmoothIndicator(
                      controller: _carouselController,
                      count: carouselItems.length,
                      activeColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                      inactiveColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                      dotWidth: 8,
                      dotHeight: 8,
                      spacing: 8,
                      radius: 4,
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Services section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppAnimations.slideIn(
                  animate: _animate,
                  beginOffset: const Offset(0, 0.2),
                  delay: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Services Available',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SalonList()),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Services grid
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return AppAnimations.fadeIn(
                      animate: _animate,
                      delay: Duration(milliseconds: 700 + (index * 100)),
                      child: _buildServiceCard(services[index], isDarkMode),
                    );
                  },
                ),
              ),
              
              // App Info Card
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: AppAnimations.fadeIn(
                  animate: _animate,
                  delay: const Duration(milliseconds: 1200),
                  child: _buildAppInfoCard(isDarkMode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
              image: DecorationImage(
                image: const AssetImage('assets/images/drawer_bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  (isDarkMode ? AppColors.siennaDark : AppColors.sienna).withOpacity(0.7),
                  BlendMode.multiply,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: userData['profile_picture'] != null &&
                      userData['profile_picture'].isNotEmpty
                      ? NetworkImage(userData['profile_picture'])
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  userData['username'] ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email'] ?? 'user@example.com',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'My Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            icon: Icons.calendar_today,
            title: 'My Appointments',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAppointmentsPage()),
              );
            },
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            icon: Icons.store,
            title: 'Browse Salons',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalonList()),
              );
            },
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: 'Favorites',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Favorites coming soon!'),
                  backgroundColor: isDarkMode ? AppColors.sienna : AppColors.sienna,
                ),
              );
            },
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            isDarkMode: isDarkMode,
          ),
          Divider(
            color: isDarkMode ? AppColors.siennaLight.withOpacity(0.3) : AppColors.sienna.withOpacity(0.2),
            thickness: 1,
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Help & Support coming soon!'),
                  backgroundColor: isDarkMode ? AppColors.sienna : AppColors.sienna,
                ),
              );
            },
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('About Us coming soon!'),
                  backgroundColor: isDarkMode ? AppColors.sienna : AppColors.sienna,
                ),
              );
            },
            isDarkMode: isDarkMode,
          ),
          Divider(
            color: isDarkMode ? AppColors.siennaLight.withOpacity(0.3) : AppColors.sienna.withOpacity(0.2),
            thickness: 1,
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
            isDarkMode: isDarkMode,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Developed by GROUP SIX',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppColors.siennaLight.withOpacity(0.7) : AppColors.sienna.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? (isDarkMode ? AppColors.siennaLight : AppColors.sienna),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? (isDarkMode ? Colors.white : Colors.black87),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      hoverColor: isDarkMode ? AppColors.sienna.withOpacity(0.1) : AppColors.siennaLight.withOpacity(0.1),
      splashColor: isDarkMode ? AppColors.sienna.withOpacity(0.2) : AppColors.siennaLight.withOpacity(0.2),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.sienna.withOpacity(0.3) : AppColors.sienna.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
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
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> item, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item['image'],
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDarkMode 
                        ? AppColors.siennaDark.withOpacity(0.8)
                        : AppColors.sienna.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description'],
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        shadows: const [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Color.fromARGB(255, 0, 0, 0),
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
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, bool isDarkMode) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SalonList()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? AppColors.sienna.withOpacity(0.3) : AppColors.sienna.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  service['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        service['description'],
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.grey[400] : Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                        ),
                      ],
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

  Widget _buildAppInfoCard(bool isDarkMode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.sienna.withOpacity(0.3) : AppColors.sienna.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'About Glamazon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Glamazon is your one-stop platform for all beauty and wellness services. Book appointments with top-rated salons and professionals for hair styling, nail care, spa treatments, tattoos, and more.',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[300] : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Learn more coming soon!'),
                        backgroundColor: isDarkMode ? AppColors.sienna : AppColors.sienna,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.read_more,
                    size: 16,
                    color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  ),
                  label: Text(
                    'Learn More',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SalonList()),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 16,
                  ),
                  label: const Text('Find Services'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        title: Text(
          'Logout',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    await _fetchUserData();
    // Add any other refresh logic here
    return Future.delayed(const Duration(milliseconds: 1500));
  }
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const ImageSlider();
  }
}
