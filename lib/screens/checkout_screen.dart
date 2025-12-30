
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Mock form values
  String _address = '';
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = cart.totalAmount + 5.00; // Including delivery fee mock

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: cart.items.isEmpty 
        ? const Center(child: Text('Your cart is empty'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Order Summary Section
                  Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text('Items (${cart.itemCount})'),
                            Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const Text('Delivery Fee'),
                             const Text('\$5.00'),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                             Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Shipping Address
                  Text('Shipping Address', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter address' : null,
                    onSaved: (value) => _address = value!,
                  ),
                  
                  const SizedBox(height: 32),

                  // Payment Method
                  Text('Payment Method', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                   TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: '0000 0000 0000 0000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.length < 16 ? 'Invalid card number' : null,
                    onSaved: (value) => _cardNumber = value!,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.datetime,
                           validator: (value) => value!.isEmpty ? 'Required' : null,
                           onSaved: (value) => _expiryDate = value!,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) => value!.length < 3 ? 'Invalid CVV' : null,
                          onSaved: (value) => _cvv = value!,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _processPayment(context, cart);
                        }
                      },
                      child: const Text('Pay Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _processPayment(BuildContext context, CartProvider cart) {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    // Mock network delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      Navigator.pop(context); // Remove loading

      // Show Success
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Payment Successful!'),
          content: const Text('Your order has been placed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                cart.clear();
                Navigator.of(ctx).pop(); // Close dialog
                Navigator.of(context).pop(); // Close Checkout Screen
                // Optionally navigate to Orders/Home
              },
              child: const Text('Done'),
            )
          ],
        ),
      );
    });
  }
}
