import 'package:flutter/material.dart';
import 'package:order_it_2/components/my_cart_tile.dart';
import 'package:order_it_2/models/cart_food.dart';
import 'package:order_it_2/models/restaurant.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = _sortCartByInsertionOrder(restaurant.getUserCart);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Carrito'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: userCart.isEmpty
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              '¿Estás seguro de que quieres vaciar el carrito?'
                            ),
                            actions: [
                              TextButton(
                                child: const Text('No'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('Sí'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  restaurant.clearCart();
                                }
                              )
                            ],
                          ),
                        );
                    },
              )
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Expanded(
                child: userCart.isEmpty
                    ? const Center(child: Text('Carrito vacío'))
                    : ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          final cartFood = userCart[index];
                          return MyCartTile(cartFood: cartFood);
                        },
                      )
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 211, 211).withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox( height: 35 ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

  List<CartFood> _sortCartByInsertionOrder(List<CartFood> cart){
    cart.sort((a, b) => a.food.id.compareTo(b.food.id));
    return cart;
  }

  