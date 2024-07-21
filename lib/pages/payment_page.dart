import 'package:flutter/material.dart';
import 'package:order_it_2/models/cart_food.dart';
import 'package:order_it_2/models/restaurant.dart';
import 'package:order_it_2/pages/delivery_progress_page.dart';
import 'package:order_it_2/pages/home_page.dart';
import 'package:order_it_2/services/supabase_api.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final List<CartFood> userCart;
  static const double iva = 0.10;

  const PaymentPage({super.key, required this.userCart});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final List<CartFood> userCart = restaurant.getUserCart;
        final subtotal = (restaurant.getTotalPrice());
        final totalStr = restaurant.formatPrice(subtotal * 1.10);
        final totalDouble = subtotal * 1.10;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirma tu pago'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(ordersAllowed: true),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  size: 25,
                ),
              )
            ],
            titleSpacing: 5.2,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Tu carrito',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userCart.map((cartFood) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          cartFood.food.imagePath,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartFood.food.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${restaurant.formatPrice(cartFood.food.price * cartFood.quantity)} (${cartFood.quantity} uds.)',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (cartFood.addons.isNotEmpty)
                                  SizedBox(
                                    height: 50,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: cartFood.addons
                                          .map(
                                            (addon) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: FilterChip(
                                                label: Row(
                                                  children: [
                                                    Text(
                                                      addon.name,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        " (${addon.price.toString()}) €",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary)),
                                                  ],
                                                ),
                                                onSelected: (value) {},
                                                shape: StadiumBorder(
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 58),
                    const Divider(height: 2),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          restaurant.formatPrice(subtotal),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80), // Espacio para el botón fijo
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white, // Fondo blanco para el botón
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Mostrar la pantalla de carga
                      showLoadingDialog(context);

                      // Iniciar el proceso de pago con Stripe
                      await StripeService.stripePaymentCheckout(
                        userCart,
                        totalStr,
                        context,
                        mounted,
                        onSuccess: () async {
                          final SupabaseApi supabaseApi = SupabaseApi();

                          // Guardar el carrito en Supabase
                          await supabaseApi.createCart(
                            restaurant.getUserCart,
                            totalDouble,
                          );

                          // Cerrar la pantalla de carga
                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          // Verificar si el contexto está montado antes de navegar
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DeliveryProgressPage(),
                              ),
                            );
                          }
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 14, 80, 44),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text('Finalizar compra'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Procesando..."),
              ],
            ),
          ),
        );
      },
    );
  }
}