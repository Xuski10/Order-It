import 'package:flutter/material.dart';
import 'package:order_it_2/models/restaurant.dart';
import 'package:order_it_2/pages/home_page.dart';
import 'package:provider/provider.dart';

class MyReceipt extends StatelessWidget {
  const MyReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Gracias por su visita!'),
            const SizedBox( height: 25 ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.all(25),
              child: Consumer<Restaurant>(
                builder: (context, restaurant, child) => 
                Text(restaurant.displayCartReceipt()),
              ),
            ),
            const SizedBox( height: 25 ),

            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 7, 114, 255)
                )
              ),
              onPressed: () {
                Provider.of<Restaurant>(context, listen: false).clearCart();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(ordersAllowed: true)
                  )
                );
              },
              child: const Text(
                'Volver a la carta',
                style: TextStyle(color: Colors.white),
              )
            )
          ],
        ),
      ),
    );
  }
}