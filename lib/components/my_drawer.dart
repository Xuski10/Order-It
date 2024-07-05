import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  final bool ordersAllowed;

  const MyDrawer({super.key, required this.ordersAllowed});

  // Menú desplegable con o sin carrito
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
        ],
      ),
    );
  }
}