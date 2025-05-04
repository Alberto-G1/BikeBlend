import 'package:flutter/material.dart';
import 'package:veloce/screens/admin_dashboard_screen.dart';
import 'package:veloce/screens/bikes.dart';
import 'package:veloce/screens/home_screen.dart';
import 'package:veloce/screens/login_screen.dart';
import 'package:veloce/screens/manage_bikes_screen.dart';
import 'package:veloce/screens/notifications_screen.dart';
// import 'package:veloce/screens/onboarding_screen.dart';
import 'package:veloce/screens/payment_screen.dart';
import 'package:veloce/screens/profile_screen.dart';
import 'package:veloce/screens/qr_scanner_screen.dart';
import 'package:veloce/screens/referral_screen.dart';
import 'package:veloce/screens/ride_history_screen.dart';
import 'package:veloce/screens/ride_tracking_screen.dart';
import 'package:veloce/screens/unlock_simulation_screen.dart';
import 'package:veloce/screens/wallet_screen.dart';


Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const LoginScreen(),
  '/home': (_) => const HomeScreen(),
  '/notifications': (_) => const NotificationScreen(),
  '/qr': (_) => const QRScannerScreen(),
  '/tracking': (_) => const RideTrackingScreen(),
  '/wallet': (_) => const WalletScreen(),
  '/payment': (_) => const PaymentScreen(),
  '/history': (_) => const RideHistoryScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/referral': (_) => const ReferralScreen(),
  '/admin': (_) => const AdminDashboardScreen(),
  '/manage_bikes': (_) => const ManageBikesScreen(),
  '/unlock_sim': (_) => const UnlockSimulationScreen(),
  '/bikes': (_) => const BikesScreen(),
};
