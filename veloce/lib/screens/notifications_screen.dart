import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifications = [
      {
        'title': 'Ride Completed',
        'subtitle': 'You earned 2 points for your recent ride.',
        'icon': Icons.check_circle_outline,
      },
      {
        'title': 'Payment Successful',
        'subtitle': 'UGX 1,500 was charged for your last ride.',
        'icon': Icons.payment_outlined,
      },
      {
        'title': 'New Bike Station Nearby',
        'subtitle': 'A new bike station opened at Wandegeya.',
        'icon': Icons.location_on_outlined,
      },
      {
        'title': 'Invite & Earn',
        'subtitle': 'Invite friends and earn 5 free rides!',
        'icon': Icons.card_giftcard_outlined,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 25),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(10),
            tileColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              child: Icon(notif['icon'] as IconData,
                  color: theme.colorScheme.primary),
            ),
            title: Text(
              notif['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(notif['subtitle'] as String),
          );
        },
      ),
    );
  }
}
