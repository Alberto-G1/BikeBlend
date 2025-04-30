import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Veloce", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      drawer: _buildAppDrawer(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, Rider 👋",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Find bikes near you or scan to unlock.",
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const QRScannerScreen(),
                              transitionsBuilder: (_, anim, __, child) =>
                                  SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                    parent: anim, curve: Curves.easeOut)),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: "qr-btn",
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Icon(Icons.qr_code_scanner_rounded,
                                  size: 60, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Your Stats",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statBox(theme, "Rides", "28", Icons.directions_bike_rounded),
                          _statBox(theme, "KM", "117", Icons.speed),
                          _statBox(theme, "CO₂ Saved", "9kg", Icons.eco_outlined),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Recent Rides",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(3, (index) => _recentRideCard(theme)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statBox(ThemeData theme, String label, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _recentRideCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded,
              color: theme.colorScheme.secondary, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Makerere to Wandegeya"),
                SizedBox(height: 4),
                Text("2.3 KM • 8 mins", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text("UGX 1,500", style: TextStyle(color: Colors.teal)),
        ],
      ),
    );
  }

Drawer _buildAppDrawer(BuildContext context) {
  Theme.of(context);
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/drawer_bg.jpg"), // Your background image
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/veloce_logo.png"), // Your logo
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text(
                "Veloce",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Ride Smarter 🚴‍♂️",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home_rounded),
          title: const Text("Home"),
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),
        ListTile(
          leading: const Icon(Icons.qr_code_2_rounded),
          title: const Text("Scan QR"),
          onTap: () => Navigator.pushNamed(context, '/qr'),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle_rounded),
          title: const Text("Profile"),
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
        ListTile(
          leading: const Icon(Icons.wallet_rounded),
          title: const Text("Wallet"),
          onTap: () => Navigator.pushNamed(context, '/wallet'),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text("Ride History"),
          onTap: () => Navigator.pushNamed(context, '/history'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        const Divider(height: 30),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings_rounded),
          title: const Text("Admin Panel"),
         onTap: () => Navigator.pushNamed(context, '/admin'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          },
        ),
      ],
    ),
  );
}

}
