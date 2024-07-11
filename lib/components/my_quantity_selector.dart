import 'package:flutter/material.dart';
import 'package:order_it_2/models/food.dart';

class QuantitySelector extends StatefulWidget {

  final int initialQuantity;
  final Food food;
  final VoidCallback onIncrementAction;
  final VoidCallback onDecrementAction;
  final ValueNotifier<bool> isLoadingNotifier;

  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.food,
    required this.onIncrementAction,
    required this.onDecrementAction,
    required this.isLoadingNotifier
  });
  

  @override
  State<QuantitySelector> createState() => QuantitySelectorState();
}

class QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void increment(){
    setState(() {
      quantity++;
    });
    widget.onIncrementAction;
  }

  void decrement(){
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
    widget.onDecrementAction;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isLoadingNotifier,
      builder: (context, isLoading, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25)
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Botón decrementar
              GestureDetector(
                onTap: isLoading ? null : decrement,
                child: Icon(
                  quantity == 1 ? Icons.delete : Icons.remove,
                  size: 20,
                  color: quantity == 1
                      ? Colors.red.shade400
                      : Theme.of(context).colorScheme.primary
                ),
              ),
              // Contador de cantidad
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 20,
                  width: 25,
                  child: Center(
                    child: Text(quantity.toString()),
                  ),
                ),
              ),
              // Botón incrementar
              GestureDetector(
                onTap: isLoading ? null : increment,
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}