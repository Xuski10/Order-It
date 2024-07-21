import 'package:flutter/material.dart';
import 'package:order_it_2/models/cart_food.dart';
import 'package:order_it_2/pages/payment_page.dart';

class MyPayButton extends StatelessWidget {
  const MyPayButton({
    super.key,
    required this.userCart
  });

  final List<CartFood> userCart;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Colors.green
        )
      ),
      onPressed: userCart.isEmpty
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(userCart: userCart),
                )
          ),
      child: SizedBox(
        width: 80,
        height: 45,
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'PAGAR',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900
            ),
          ),
        ),
      )
    );
  }
}