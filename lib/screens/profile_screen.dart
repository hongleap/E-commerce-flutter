
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            const SizedBox(height: 16),
            Text(
              'Alex Doe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'alex.doe@example.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 32),

            // Settings List
            _buildProfileItem(context, 'Edit Profile', Icons.person_outline),
            _buildProfileItem(context, 'Orders', Icons.shopping_bag_outlined),
            _buildProfileItem(context, 'Wishlist', Icons.favorite_border),
            _buildProfileItem(context, 'Shipping Address', Icons.location_on_outlined),
             _buildProfileItem(context, 'Payment Methods', Icons.payment_outlined),
            
            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'), // Simplified for this demo
              secondary: const Icon(Icons.dark_mode_outlined),
              value:  Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                 Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
              },
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 16),
      onTap: () {},
    );
  }
}
