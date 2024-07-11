import 'package:flutter/material.dart';

class AnimatedPrice extends StatelessWidget {
  final String price;
  final bool isLoading;

  const AnimatedPrice({
    super.key,
    required this.price,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          ),
        );
      },
      child: isLoading
          ? LinearProgressIndicator(
              key: const ValueKey('loading'),
              backgroundColor: Colors.grey.shade300,
              color: Colors.grey.shade500,
            )
          : Text(
              price,
              key: ValueKey(price),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary
              ),
            )
    );
  }
}