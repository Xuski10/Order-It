import 'package:flutter/material.dart';
import 'package:order_it_2/components/animated_price.dart';
import 'package:order_it_2/components/my_quantity_selector.dart';
import 'package:order_it_2/models/cart_food.dart';
import 'package:order_it_2/models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatefulWidget {
  final CartFood cartFood;

  const MyCartTile({super.key, required this.cartFood});

  @override
  MyCartTileState createState() => MyCartTileState();
}

class MyCartTileState extends State<MyCartTile> {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plato
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.cartFood.food.imagePath,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nombre y precio
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.cartFood.food.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedPrice(
                              key: ValueKey(
                                  'price_${widget.cartFood.food.id}'), // Key única para el precio
                              price: restaurant.formatPrice(
                                widget.cartFood.food.price *
                                    widget.cartFood.quantity,
                              ),
                              isLoading: isLoadingNotifier.value,
                            ),
                            QuantitySelector(
                              key: ValueKey(
                                  'selector_${widget.cartFood.food.id}'), // Key única para el selector de cantidad
                              initialQuantity: widget.cartFood.quantity,
                              food: widget.cartFood.food,
                              onIncrementAction: () =>
                                  handleIncrement(restaurant),
                              onDecrementAction: () =>
                                  handleDecrement(restaurant),
                              isLoadingNotifier: isLoadingNotifier,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Addons
            if (widget.cartFood.addons.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: widget.cartFood.addons
                        .map(
                          (addon) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Row(
                                children: [
                                  Text(
                                    addon.name,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Text(" (${addon.price.toString()})€",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary))
                                ],
                              ),
                              onSelected: (value) {},
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              labelStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> handleIncrement(Restaurant restaurant) async {
    isLoadingNotifier.value = true;
    await restaurant.addToCart(widget.cartFood.food, widget.cartFood.addons);
    isLoadingNotifier.value = false;
  }

  Future<void> handleDecrement(Restaurant restaurant) async {
    isLoadingNotifier.value = true;
    await restaurant.removeFromCart(widget.cartFood);
    isLoadingNotifier.value = false;
  }
}