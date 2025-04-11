// import 'package:flutter/material.dart';
// import 'package:bike_bliss/screens/home_screen.dart';
// import 'package:bike_bliss/screens/map_screen.dart';
// import 'package:bike_bliss/screens/scan_screen.dart';
// import 'package:bike_bliss/screens/rides_screen.dart';
// import 'package:bike_bliss/screens/profile_screen.dart';
// import 'package:bike_bliss/theme/app_theme.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   late TabController _tabController;
  
//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const MapScreen(),
//     const ScanScreen(),
//     const RidesScreen(),
//     const ProfileScreen(),
//   ];
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _screens.length, vsync: this);
//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         setState(() {
//           _currentIndex = _tabController.index;
//         });
//       }
//     });
//   }
  
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: TabBarView(
//         controller: _tabController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: _screens,
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           child: BottomNavigationBar(
//             currentIndex: _currentIndex,
//             onTap: (index) {
//               setState(() {
//                 _currentIndex = index;
//                 _tabController.animateTo(index);
//               });
//             },
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? const Color(0xFF1E1E1E)
//                 : Colors.white,
//             selectedItemColor: AppTheme.primaryColor,
//             unselectedItemColor: Theme.of(context).brightness == Brightness.dark
//                 ? Colors.white54
//                 : Colors.black54,
//             showSelectedLabels: true,
//             showUnselectedLabels: true,
//             selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//             unselectedLabelStyle: const TextStyle(fontSize: 10),
//             elevation: 0,
//             items: [
//               _buildNavItem(Icons.home_outlined, Icons.home, "Home"),
//               _buildNavItem(Icons.map_outlined, Icons.map, "Map"),
//               _buildNavItem(Icons.qr_code_scanner_outlined, Icons.qr_code_scanner, "Scan"),
//               _buildNavItem(Icons.history_outlined, Icons.history, "Rides"),
//               _buildNavItem(Icons.person_outline, Icons.person, "Profile"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   BottomNavigationBarItem _buildNavItem(IconData unselectedIcon, IconData selectedIcon, String label) {
//     return BottomNavigationBarItem(
//       icon: Icon(unselectedIcon),
//       activeIcon: Icon(selectedIcon),
//       label: label,
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:bike_bliss/screens/home_screen.dart';
import 'package:bike_bliss/screens/map_screen.dart';
import 'package:bike_bliss/screens/scan_screen.dart';
import 'package:bike_bliss/screens/rides_screen.dart';
import 'package:bike_bliss/screens/profile_screen.dart';
import 'package:bike_bliss/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const MapScreen(),
    const ScanScreen(),
    const RidesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).cardColor,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "Map",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                  ),
                ),
                label: "Scan",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.directions_bike),
                label: "Rides",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
