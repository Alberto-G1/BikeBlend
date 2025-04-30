import 'package:flutter/material.dart';
import 'package:veloce/screens/admin_dashboard_screen.dart';
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
  // '/': (_) => const OnboardingScreen(),
  '/login': (_) => const LoginScreen(),
  // '/signup': (_) => const SignupScreen(),
  '/home': (_) => const HomeScreen(),
  '/notifications': (_) => const NotificationScreen(),
  '/qr': (_) => const QRScannerScreen(),
  // '/unlock_success': (_) => const RideUnlockSuccessScreen(),
  '/tracking': (_) => const RideTrackingScreen(),
  '/wallet': (_) => const WalletScreen(),
  '/payment': (_) => const PaymentScreen(),
  // '/transactions': (_) => const TransactionsScreen(),
  '/history': (_) => const RideHistoryScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/referral': (_) => const ReferralScreen(),
  // '/invite': (_) => const InviteFriendsScreen(),
  '/admin': (_) => const AdminDashboardScreen(),
  '/manage_bikes': (_) => const ManageBikesScreen(),
  '/unlock_sim': (_) => const UnlockSimulationScreen(),
};
