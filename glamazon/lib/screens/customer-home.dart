import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/config/theme/theme_toggle.dart';
import 'package:glamazon/reusable_widgets/smooth_page_indicator.dart';
import 'package:glamazon/screens/welcome_screen.dart';
import 'package:glamazon/screens/customer_profile-details.dart';
import 'package:glamazon/screens/salon_list.dart';
import 'package:glamazon/screens/user_appointments.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/utils/colors.dart';
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
            ? Colors.black 
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
            ),
          ),
        ),
        actions: [
          ThemeToggle(iconColor: Colors.white),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.sienna,
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
                    activeColor: isDarkMode ? Colors.tealAccent : AppColors.sienna,
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
                        color: isDarkMode ? Colors.white : AppColors.sienna,
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
                              color: isDarkMode ? Colors.tealAccent : AppColors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: isDarkMode ? Colors.tealAccent : AppColors.teal,
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
          ],
        ),
      ),
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
              color: isDarkMode ? Colors.teal.shade900 : AppColors.sienna.withOpacity(0.1),
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
              color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
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
                    Colors.black.withOpacity(0.7),
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description'],
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
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
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                        color: isDarkMode ? Colors.white : Colors.black87,
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
                          color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
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

  void _showLogoutConfirmation(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.sienna,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.teal.shade700 : AppColors.sienna,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:glamazon/screens/welcome_screen.dart';
// import 'package:glamazon/screens/profile-details.dart';
// import 'package:glamazon/screens/salon_list.dart';
// import 'package:glamazon/screens/user_appointments.dart';


// class ImageSlider extends StatefulWidget {
//   const ImageSlider({super.key});

//   @override
//   State<ImageSlider> createState() => _ImageSliderState();
// }

// class _ImageSliderState extends State<ImageSlider> {
//   final myItems = [
//     'assets/images/spa/spa1.jpg',
//     'assets/images/nails/images (2).jpeg',
//     'assets/images/hair/haircut.jpeg',
//     'assets/images/piercing/peircing1.webp',
//     'assets/images/tatoo/tattoo 1.jpg',
//     'assets/images/nails/images (3).jpeg',
//     'assets/images/makeup/image03.jpg',
//     'assets/images/spa/spa.jpeg',
//     'assets/images/hair/images (12).jpeg',
//   ];

//   int myCurrentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 248, 236, 220),
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Glamazon',
//               style: TextStyle(
//                 fontFamily: 'Oswald',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 FirebaseAuth.instance.signOut().then((Value) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//                   );
//                 });
//               },
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   fontFamily: 'Oswald',
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         elevation: 3,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Image(
//                     image: AssetImage('assets/images/logo3.png'),
//                     height: 90,
//                   ),
//                   Column(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.calendar_today, color: Color(0xFF882D17), size: 30),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const UserAppointmentsPage()),
//                           );
//                         },
//                       ),
//                       const Text(
//                         'Appointments',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.person, color: Color(0xFF882D17), size: 30),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const ProfileScreen()),
//                           );
//                         },
//                       ),
//                       const Text(
//                         'Profile',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: CarouselSlider(
//                 options: CarouselOptions(
//                   autoPlay: true,
//                   height: 200,
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                   autoPlayInterval: const Duration(seconds: 2),
//                   enlargeCenterPage: true,
//                   aspectRatio: 2.0,
//                   onPageChanged: (index, reason) {
//                     setState(() {
//                       myCurrentIndex = index;
//                     });
//                   },
//                 ),
//                 items: myItems.map((item) => ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.transparent, Colors.black],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     child: Image.asset(
//                       item,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   ),
//                 )).toList(),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Text(
//                 'services available ...',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       _buildServiceItem(context, 'assets/images/hair/images (8).jpeg', 'Hair styling and Cuts'),
//                       const SizedBox(width: 16.0),
//                       _buildServiceItem(context, 'assets/images/nails/image02.jpg', 'Nails'),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
//                   Row(
//                     children: [
//                       _buildServiceItem(context, 'assets/images/spa/spa.jpg', 'Spa'),
//                       const SizedBox(width: 16.0),
//                       _buildServiceItem(context, 'assets/images/tatoo/image14.jpeg', 'Tattoos'),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
//                   Row(
//                     children: [
//                       _buildServiceItem(context, 'assets/images/makeup/makeup2.jpeg', 'Makeup and Facial'),
//                       const SizedBox(width: 16.0),
//                       _buildServiceItem(context, 'assets/images/piercing/piercing 2.jpg', 'Piercing'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceItem(BuildContext context, String imagePath, String label) {
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SalonList()),
//           );
//         },
//         child: Column(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 height: 120,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(imagePath),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
