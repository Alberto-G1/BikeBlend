import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const referralCode = "BIKE123";

    return Scaffold(
      appBar: AppBar(title: const Text("Invite Friends")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.card_giftcard, size: 80, color: theme.colorScheme.secondary),
            const SizedBox(height: 20),
            Text(
              "Invite your friends and earn free rides!",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("Your Referral Code"),
                  const SizedBox(height: 10),
                  SelectableText(
                    referralCode,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: referralCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Code copied!")),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          Share.share("Use my referral code $referralCode to get free rides!");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Invite via Apps"),
              onPressed: () {
                Share.share("Hey! Try this awesome bike app and use my code $referralCode 🚲");
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
