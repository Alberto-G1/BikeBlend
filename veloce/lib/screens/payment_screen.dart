import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();

  String selectedMethod = "VISA **** 9281";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Add Funds")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: theme.textTheme.headlineSmall,
              decoration: InputDecoration(
                labelText: "Amount",
                prefixText: "\$",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Payment Method",
                  style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 10),
            _paymentMethodCard("VISA **** 9281"),
            _paymentMethodCard("MasterCard **** 3390"),
            _paymentMethodCard("PayPal"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Confirm Payment"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Payment Successful"),
                    content: const Icon(Icons.check_circle,
                        size: 64, color: Colors.green),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        child: const Text("Done"),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodCard(String method) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedMethod = method);
      },
      child: Card(
        color: selectedMethod == method
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
            : null,
        child: ListTile(
          leading: const Icon(Icons.credit_card),
          title: Text(method),
          trailing: selectedMethod == method
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
        ),
      ),
    );
  }
}
