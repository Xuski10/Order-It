import 'package:flutter/material.dart';
import 'package:order_it_2/auth/login_or_register.dart';
import 'package:order_it_2/components/my_drawer_tile.dart';
import 'package:order_it_2/pages/cart_page.dart';
import 'package:order_it_2/pages/help_page.dart';
import 'package:order_it_2/pages/my_orders.dart';
import 'package:order_it_2/pages/my_profile.dart';
import 'package:order_it_2/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyDrawer extends StatelessWidget {

  final bool ordersAllowed;

  const MyDrawer({super.key, required this.ordersAllowed});

  // Menú desplegable con o sin carrito
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Drawer(
      width: size.width * 0.7,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  icon: const Icon(Icons.dark_mode_rounded)
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: Image.asset(
              'assets/icons/Logo.png',
              width: size.width * 0.8,
              height: size.height * 0.3,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          MyDrawerTile(
            text: 'Inicio',
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          if (ordersAllowed)
            MyDrawerTile(
              text: 'Carrito',
              icon: Icons.shopping_cart_checkout_rounded,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  )
                );
              },
            ),
          
          MyDrawerTile(
            text: 'Pedidos',
            icon: Icons.food_bank,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyOrders(),
                )
              );
            },
          ),

          MyDrawerTile(
            text: 'Mis datos',
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProfile(title: 'Mis datos'), 
                )
              );
            },
          ),

          MyDrawerTile(
            text: 'Ayuda',
            icon: Icons.help_center,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(),
                )
              );
            },
          ),

          // Tirar Logout abajo del todo
          const Spacer(),

          MyDrawerTile(
            text: 'Cerrar sesión',
            icon: Icons.logout,
            onTap: () async {
              final supabase = Supabase.instance;
              supabase.client.auth.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegister(),
                )
              );
            },
          ),

          const SizedBox( height: 25)
        ],
      ),
    );
  }
}