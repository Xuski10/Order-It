import 'package:flutter/material.dart';
import 'package:order_it_2/components/my_container.dart';
import 'package:order_it_2/pages/my_orders.dart';
import 'package:order_it_2/pages/my_profile.dart';
import 'package:order_it_2/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: const Icon(
              Icons.dark_mode_rounded,
              size: 25,
            )
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox( height: 40 ),
          const CircleAvatar( radius: 50 ),
          const SizedBox( height: 40 ),
          MyContainer(
            title: 'PEDIDOS',
            icon: const Icon(Icons.coffee),
            route: (context) => const MyOrders(),
          ),
          MyContainer(
            title: 'MIS DATOS',
            icon: const Icon(Icons.person),
            route: (context) => const MyProfile(title: 'Mis datos'),
          ),
          MyContainer(
            title: 'AYUDA',
            icon: const Icon(Icons.help),
            route: (context) => const MyOrders(),
          ),
        ],
      ),
    );
  }
}