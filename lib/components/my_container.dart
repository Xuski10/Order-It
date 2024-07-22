import 'package:flutter/material.dart';
import 'package:order_it_2/controllers/order_controller.dart';

class MyContainer extends StatefulWidget {

  final String title;
  final Icon icon;
  final WidgetBuilder route;

  const MyContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.route
  });

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {

  final OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: widget.route
          )
        );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(76.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.icon,
              const SizedBox( width: 25 ),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.inversePrimary
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}